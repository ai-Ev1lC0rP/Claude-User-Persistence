#!/bin/bash

# toDo Agent (n8n MCP Remote)
# Specialized for task and workflow management via n8n
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$N8N_AUTH_TOKEN" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              toDo AGENT - Task & Workflow Management         ║
╚══════════════════════════════════════════════════════════════╝

This agent specializes in:
  • Task creation and management
  • Workflow automation and orchestration
  • n8n workflow execution via remote MCP
  • Task scheduling and automation
  • Workflow state tracking
  • Integration with other systems

Capabilities:
  • Execute workflows defined in n8n
  • Create and manage tasks
  • Retrieve workflow status
  • Manage workflow executions
  • Integration with webhook endpoints

Environment:
  - N8N_AUTH_TOKEN loaded from environment
  - N8N_ENDPOINT: n8n.tsargent.work
  - MCP_WORKFLOW_ID: configured per environment
  - LOG_DIR: configured per environment

Authentication: Bearer token

Connection:
  - Remote MCP via n8n webhook endpoint
  - Stdio transport for Claude integration

EOF

echo "🚀 Starting toDo Agent..."
echo "   Environment: $ENV"
echo "   Endpoint: ${N8N_ENDPOINT:-n8n.tsargent.work}"
echo "   Auth Token: ${N8N_AUTH_TOKEN:0:10}..."
echo ""

# Execute n8n toDo MCP remote
# Using mcp-remote tool to connect to n8n webhook endpoint
exec npx mcp-remote \
  "${N8N_MCP_ENDPOINT:-https://n8n.tsargent.work/mcp/32d71f33-6dfd-4ac4-9987-51b14d00f81e}" \
  --header "Authorization: Bearer ${N8N_AUTH_TOKEN:-init2Win}"
