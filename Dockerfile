# Use a slim, secure base image
FROM python:3.11-slim

# Set environment variables for better logging and behavior
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Install git and curl for health checks and repository operations
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN groupadd -r agentuser && useradd -r -g agentuser agentuser

# Install dependencies first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY main.py mcp_client.py mcp_server_config.json .env ./
COPY sql ./sql

# Create directory for agent outputs and set permissions
RUN mkdir -p generated_outputs && \
    chown -R agentuser:agentuser /app

# Switch to non-root user
USER agentuser

# Expose port 8080 for Bedrock AgentCore
EXPOSE 8080

# Healthy check to ensure app is running
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["python", "main.py"]
