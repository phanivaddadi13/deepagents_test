
from logging import INFO, basicConfig, getLogger
import os
import asyncio
from dotenv import load_dotenv
load_dotenv()
import json
from typing import Any, Dict, List
from bedrock_agentcore import BedrockAgentCoreApp
from deepagents import create_deep_agent
from deepagents.backends import FilesystemBackend

import re
import botocore.client

basicConfig(level="INFO")
logger = getLogger(__name__)

# --- BOTOCORE MONKEYPATCH (FORBIDDEN ID FIX) ---
def sanitize_bedrock_body(body):
    if isinstance(body, (bytes, str)):
        body_str = body.decode('utf-8') if isinstance(body, bytes) else body
        try:
            data = json.loads(body_str)
            def strip_id(obj):
                if isinstance(obj, list):
                    for item in obj: strip_id(item)
                elif isinstance(obj, dict):
                    if obj.get("type") == "text" and "id" in obj:
                        logger.debug(f"Stripping ID: {obj['id']}")
                        del obj["id"]
                    for k, v in obj.items(): strip_id(v)
            strip_id(data)
            return json.dumps(data).encode('utf-8')
        except:
            return body
    return body

original_make_api_call = botocore.client.BaseClient._make_api_call
def new_make_api_call(self, operation_name, kwargs):
    if operation_name == "InvokeModel" and "body" in kwargs:
        kwargs["body"] = sanitize_bedrock_body(kwargs["body"])
    return original_make_api_call(self, operation_name, kwargs)

botocore.client.BaseClient._make_api_call = new_make_api_call

from mcp_client import init_mcp

# Initialize MCP and Event Loop
loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)

try:
    logger.info("Initializing GitHub MCP Client...")
    all_tools = loop.run_until_complete(init_mcp())
    
    if not all_tools:
        raise RuntimeError("No tools returned from MCP. Check credentials.")

    allowed_tools = ["create_branch", "push_files", "create_pull_request", "get_file_contents", "create_or_update_file", "list_branches"]
    github_tools = [t for t in all_tools if t.name in allowed_tools]
    
    logger.info(f"Loaded {len(github_tools)} GitHub tools.")
except Exception as e:
    logger.critical(f"Setup Failed: {e}")
    raise

app = BedrockAgentCoreApp()

# --- SUBAGENTS ---

developer_agent = create_deep_agent(
    model="anthropic.claude-3-5-sonnet-20240620-v1:0",
    backend=FilesystemBackend(root_dir="./generated_outputs/dev", virtual_mode=True),
    tools=github_tools,
    system_prompt="""
        You are the **Developer Agent**.
        Your ONLY job is to convert SQL to PySpark and PUSH IT to GitHub.
        Repo: 'phanivaddadi13/deepagents_test'
        
        ### EXECUTION STEPS:
        1. Call `create_branch` with a unique name (e.g., `feature/sql-pyspark-<id>`).
        2. Call `push_files` to write the PySpark conversion to a file named `conversion.py`.
        
        DO NOT JUST TALK. CALL THE TOOLS. 
        Once `push_files` returns success, report the branch name and filename.
    """
)

reviewer_agent = create_deep_agent(
    model="anthropic.claude-3-5-sonnet-20240620-v1:0",
    backend=FilesystemBackend(root_dir="./generated_outputs/review", virtual_mode=True),
    tools=github_tools,
    system_prompt="""
        You are the **Reviewer Agent**.
        Your job is to VALIDATE the code on GitHub.
        Repo: 'phanivaddadi13/deepagents_test'
        
        ### EXECUTION STEPS:
        1. Call `get_file_contents` for the branch and file provided by the Developer.
        2. If the code looks correct, report 'REVIEW_PASSED'.
        3. If there are issues, tell the Developer to fix it.
        
        DO NOT ASSUME. CALL `get_file_contents` TO SEE THE ACTUAL CODE.
    """
)

lead_agent = create_deep_agent(
    model="anthropic.claude-3-5-sonnet-20240620-v1:0",
    backend=FilesystemBackend(root_dir="./generated_outputs/lead", virtual_mode=True),
    subagents=[
        {
            "agent": developer_agent, 
            "name": "developer_agent", 
            "description": "Expert at SQL-to-PySpark conversion and branch/push operations.",
            "system_prompt": "Convert SQL to PySpark and call create_branch + push_files."
        },
        {
            "agent": reviewer_agent, 
            "name": "reviewer_agent", 
            "description": "Expert at code review and validation using get_file_contents.",
            "system_prompt": "Call get_file_contents to review the pushed code."
        }
    ],
    tools=github_tools,
    system_prompt="""
        You are the **Lead Orchestrator**.
        Your Goal: Complete the SQL-to-PySpark workflow on repository 'phanivaddadi13/deepagents_test'.
        
        ### ORCHESTRATION FLOW:
        1. Ask **developer_agent** to convert the SQL and push it to a new branch.
        2. Ask **reviewer_agent** to verify the branch and file using `get_file_contents`.
        3. If **reviewer_agent** reports 'REVIEW_PASSED', YOU MUST CALL `create_pull_request` yourself.
        
        ### CRITICAL:
        - You HAVE the `create_pull_request` tool. CALL IT.
        - Do not stop until the PR is created.
        - Use the branch name provided by the Developer for the `head` parameter in `create_pull_request`.
    """
)


@app.entrypoint
def invoke(payload: dict):
    """
    Expected payload:
    {
        "prompt": "select * from customers"
    }
    """

    user_sql = payload.get("prompt")
    if "input" in payload and isinstance(payload["input"], dict):
        user_sql = payload["prompt"]

    if not user_sql:
        return {"error": "Missing 'prompt' field"}

    response = loop.run_until_complete(lead_agent.ainvoke({
        "messages": [
            {"role": "user", 
            "content": user_sql}
        ]
    }))

    return {
        "status": "Multi-Agent execution completed",
        "result": str(response["messages"][-1].content)
    }

if __name__ == "__main__":
    app.run()