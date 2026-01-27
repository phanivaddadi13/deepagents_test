
import os
import json
import httpx
from logging import getLogger
from typing import Any, Dict, List
from langchain_mcp_adapters.tools import load_mcp_tools
from mcp.types import Tool, CallToolResult, ListToolsResult

logger = getLogger(__name__)

class StatelessGitHubSession:
    def __init__(self, token: str):
        self.url = "https://api.githubcopilot.com/mcp/"
        self.token = token
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream", 
            "User-Agent": "deepagents-mcp/1.0"
        }
        self.client = httpx.AsyncClient(headers=self.headers, timeout=30.0)

    async def _send_batch(self, requests: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        init_req = {
            "jsonrpc": "2.0",
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05", 
                "capabilities": {},
                "clientInfo": {"name": "deepagent", "version": "1.0"}
            },
            "id": "init"
        }
        batch = [init_req] + requests
        logger.debug(f"Sending batch to {self.url}: {[r.get('method') for r in batch]}")
        
        try:
            resp = await self.client.post(self.url, json=batch)
            resp.raise_for_status()
            
            results = []
            if "text/event-stream" in resp.headers.get("content-type", ""):
                 for line in resp.text.splitlines():
                     if line.startswith("data:"):
                         try:
                             data = json.loads(line[5:].strip())
                             results.append(data)
                         except:
                             pass
            else:
                results = resp.json()
                if not isinstance(results, list):
                    results = [results]
            
            final_results = [r for r in results if r.get("id") != "init"]
            return final_results
        except Exception as e:
            logger.error(f"Stateless Request Failed: {e}")
            raise

    async def list_tools(self, cursor: str = None) -> ListToolsResult:
        logger.info(f"Stateless: Fetching tool list... (cursor={cursor})")
        params = {}
        if cursor: params["cursor"] = cursor
        req = {"jsonrpc": "2.0", "method": "tools/list", "params": params, "id": "tools_list"}
        
        responses = await self._send_batch([req])
        result = next((r for r in responses if r.get("id") == "tools_list"), None)
        if not result or "error" in result: raise RuntimeError(f"Error fetching tools: {result}")
        
        tools_data = result["result"].get("tools", [])
        return ListToolsResult(tools=[Tool(**t) for t in tools_data], nextCursor=result["result"].get("nextCursor"))

    async def call_tool(self, name: str, arguments: dict = None, **kwargs) -> CallToolResult:
        logger.info(f"Stateless: Calling tool {name}...")
        if arguments is None: arguments = {}
        req = {"jsonrpc": "2.0", "method": "tools/call", "params": {"name": name, "arguments": arguments}, "id": "tool_call"}
        
        responses = await self._send_batch([req])
        result = next((r for r in responses if r.get("id") == "tool_call"), None)
        if not result or "error" in result: raise RuntimeError(f"Error calling tool: {result}")
        
        tool_res = result["result"]
        tool_res.pop("id", None)
        
        raw_content = tool_res.get("content", [])
        flattened_text = json.dumps(raw_content, default=str)
        
        tool_res["content"] = [
            {
                "type": "text", 
                "text": flattened_text
            }
        ]
        
        return CallToolResult(
            content=tool_res["content"],
            isError=tool_res.get("isError", False)
        )

async def init_mcp():
    env_token = os.environ.get("GITHUB_PERSONAL_ACCESS_TOKEN") or os.environ.get("GITHUB_TOKEN")
    
    def is_placeholder(t):
        if not t: return True
        t = t.strip().strip('"').strip("'")
        placeholders = ["xxx", "REPLACE_ME", "REPLACE_WITH_YOUR_TOKEN", "YOUR_TOKEN", "YOUR_REAL_TOKEN_HERE"]
        if t in placeholders or len(t) < 10: return True
        if "TOKEN" in t.upper() and len(t) < 30: return True 
        return False

    token = None
    if not is_placeholder(env_token):
        token = env_token.strip().strip('"').strip("'")
        logger.info(f"Using GitHub token from environment variables. (Prefix: {token[:4]}..., Length: {len(token)})")
    
    if not token and os.path.exists("mcp_server_config.json"):
        try:
            with open("mcp_server_config.json") as f:
                c = json.load(f)
                servers = c.get("mcpServers", c.get("servers", {}))
                github_conf = servers.get("github", {})
                auth = github_conf.get("headers", {}).get("Authorization", "")
                
                if auth.startswith("Bearer "):
                    potential_token = auth.replace("Bearer ", "").strip().strip('"').strip("'")
                    if not is_placeholder(potential_token):
                        token = potential_token
                        logger.info(f"Using GitHub token from mcp_server_config.json. (Prefix: {token[:4]}..., Length: {len(token)})")
        except Exception as e:
            logger.warning(f"Failed to read config: {e}")

    if not token:
        logger.error("Missing Valid Token: Env vars and config file both contain placeholders or are missing.")
        return []

    return await load_mcp_tools(StatelessGitHubSession(token))
