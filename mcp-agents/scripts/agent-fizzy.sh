#!/bin/bash

# Fizzy Agent
# Specialized for project and task management
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$FIZZY_API_KEY" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║            FIZZY AGENT - Project Management                     ║
╚══════════════════════════════════════════════════════════════════╝

This agent specializes in:
  • Basecamp board and project management
  • Task and card creation/management
  • Team collaboration and assignments
  • Progress tracking and updates
  • Comments and discussions
  • Tag and category management
  • Notification handling

Available Methods: 24
  - Board operations (list, get, create, update)
  - Card operations (list, get, create, update, assign, tag)
  - Comment operations (list, create, update, delete)
  - Step operations (list, create, update, delete)
  - Tag operations (list, apply)
  - User operations (list, get)
  - Notification operations (list, mark read)

Environment:
  - FIZZY_API_KEY loaded from environment
  - LOG_DIR: configured per environment
  - LOG_LEVEL: configured per environment

EOF

echo "🚀 Starting Fizzy Agent..."
echo "   Environment: $ENV"
echo "   API Key: ${FIZZY_API_KEY:0:10}..."
echo ""

# Navigate to Fizzy MCP server
cd ~/Development/fizzy-mcp-server
exec node dist/index.js
