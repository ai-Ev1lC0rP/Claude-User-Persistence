#!/bin/bash

# Notion Agent
# Specialized for document management, parsing, and consolidation
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$NOTION_API_TOKEN" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║            NOTION AGENT - Document Management                   ║
╚══════════════════════════════════════════════════════════════════╝

This agent specializes in:
  • Parsing multiple document formats (PDF, Markdown, CSV, Excel)
  • Creating Notion pages and databases
  • Consolidating documents and information
  • Building searchable databases
  • Organizing and tagging documents
  • Document metadata extraction

Available Methods: 7
  - parse_document (PDF, Markdown, CSV, Excel, Text)
  - create_page
  - create_database
  - list_pages
  - add_block
  - add_database_entry
  - query_database

Environment:
  - NOTION_API_TOKEN loaded from environment
  - LOG_DIR: configured per environment
  - LOG_LEVEL: configured per environment

EOF

echo "🚀 Starting Notion Agent..."
echo "   Environment: $ENV"
echo "   Token: ${NOTION_API_TOKEN:0:10}..."
echo ""

# Navigate to Notion MCP server
cd ~/Development/notion-mcp-server
exec node dist/index.js
