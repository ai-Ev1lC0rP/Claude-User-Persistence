#!/bin/bash

# n8n MCP Agent
# Specialized for n8n workflow management and automation
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$N8N_API_URL" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              n8n MCP AGENT - Workflow Automation             ║
╚══════════════════════════════════════════════════════════════╝

This agent specializes in:
  • n8n workflow management and execution
  • Automation of complex multi-step processes
  • Integration between multiple systems
  • Workflow monitoring and error handling
  • Data transformation and mapping
  • Scheduled execution and triggers

Capabilities:
  • List and execute workflows
  • Manage workflow variables
  • Monitor execution status
  • Handle errors and retries
  • Integrate with webhooks
  • Connect multiple data sources
  • Transform and process data
  • Schedule automated tasks

Available Methods:
  - Workflow operations (list, get, execute, update)
  - Execution monitoring (list, get, retry)
  - Variable management (get, set, delete)
  - Integration operations
  - Data transformation tools

Environment:
  - N8N_API_URL loaded from environment
  - N8N_API_KEY loaded from environment
  - MCP_MODE: stdio (for Claude integration)
  - LOG_LEVEL: configured per environment
  - LOG_DIR: configured per environment

Authentication: API key (bearer token)

EOF

echo "🚀 Starting n8n MCP Agent..."
echo "   Environment: $ENV"
echo "   API URL: ${N8N_API_URL}"
echo "   API Key: ${N8N_API_KEY:0:10}..."
echo ""

# Set n8n MCP environment variables
export MCP_MODE="stdio"
export LOG_LEVEL="${LOG_LEVEL:-error}"
export DISABLE_CONSOLE_OUTPUT="true"

# Execute n8n MCP server
exec npx n8n-mcp
