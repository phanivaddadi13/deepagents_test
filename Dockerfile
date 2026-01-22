FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py deep_agent_env.py ./
COPY sql ./sql

# IMPORTANT: do NOT expose ports, do NOT run uvicorn
CMD ["python", "main.py"]
