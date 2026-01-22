
# from bedrock_agentcore.runtime import BedrockAgentCoreApp
# from langchain_aws import ChatBedrockConverse
# # from langchain.schema import HumanMessage

# app = BedrockAgentCoreApp()

# llm = ChatBedrockConverse(
#     model_id="anthropic.claude-3-5-sonnet-20240620-v1:0"
# )

# SYSTEM_PROMPT = """
#     You are a senior data engineer.

#     Rules:
#     - Input is SQL
#     - Output ONLY valid PySpark DataFrame code
#     - Use spark.table("table_name")
#     - Use pyspark.sql.functions as F
#     - Final dataframe name must be df_result
#     - No explanations

#     """

# @app.entrypoint
# def sql_to_pyspark(payload: dict):
#     """
#     Expected payload:
#     {
#         "prompt": "select * from customers"
#     }
#     """

#     user_sql = payload.get("prompt")
#     if "input" in payload and isinstance(payload["input"], dict):
#         user_sql = payload["prompt"]

#     if not user_sql:
#         return {"error": "Missing 'prompt' field"}

#     messages = [
#         (
#             "system", SYSTEM_PROMPT
#         ),
#         ("human", f"""Convert the following SQL into PySpark code.
#                                     SQL: "{user_sql} "
#                             """),
#     ]
#     response = llm.invoke(messages)

#     return {
#         "pyspark_code": response.content
#     }

# if __name__ == "__main__":
#     app.run()





from logging import INFO, basicConfig, getLogger
from uuid import uuid4
import os
from datetime import datetime

from bedrock_agentcore import BedrockAgentCoreApp
from deepagents import create_deep_agent
from deepagents.backends import FilesystemBackend
from langgraph.config import RunnableConfig


def save_to_file(content: str, folder: str = "generated_outputs"):
    """Saves content to a file with a timestamped name in the specified folder."""
    if not os.path.exists(folder):
        os.makedirs(folder)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"output_{timestamp}.py"
    filepath = os.path.join(folder, filename)
    
    with open(filepath, "w") as f:
        f.write(str(content))
    
    return filepath


basicConfig(level=INFO)

logger = getLogger(__name__)

app = BedrockAgentCoreApp()
agent = create_deep_agent(
    model="anthropic.claude-3-5-sonnet-20240620-v1:0",
    backend=FilesystemBackend(root_dir="./generated_outputs", virtual_mode=True),
    system_prompt = """
        You are a senior data engineer.

        Your task:
            - Convert SQL into valid PySpark DataFrame code
            - Then create a GitHub Pull Request with the generated code

        Rules:
            - Input is SQL
            - Output ONLY valid PySpark DataFrame code
            - Use spark.table("table_name")
            - Use pyspark.sql.functions as F
            - Final dataframe name must be df_result
            - No explanations

        GitHub workflow:
            1. Create a new branch named auto/pyspark/<timestamp>
            2. Write the PySpark code to generated/pyspark/query_<timestamp>.py
            3. Commit the file
            4. Open a pull request to main
        """
    )



@app.entrypoint
def sql_to_pyspark(payload: dict):
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

    response = agent.invoke({
        "messages": [
            {"role": "user", 
            "content": user_sql}
        ]
    })

    pyspark_code = response["messages"][-1].content
    saved_path = save_to_file(pyspark_code)
    logger.info(f"Generated PySpark code saved to: {saved_path}")

    return {
        "status": "PR created",
        "result": response["messages"][-1].content
    }

if __name__ == "__main__":
    app.run()