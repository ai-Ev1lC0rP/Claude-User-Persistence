#!/bin/bash

# Lokka Agent
# Specialized for Microsoft 365, Azure, and Entra ID management
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$TENANT_ID" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║      LOKKA AGENT - Azure & Microsoft 365 Management             ║
╚══════════════════════════════════════════════════════════════════╝

This agent specializes in:
  • Azure resource management and querying
  • Microsoft Entra ID (formerly Azure AD) administration
  • Conditional access policy management
  • Intune device configuration management
  • Teams and SharePoint management
  • Security group creation and management
  • Microsoft 365 license management
  • Azure cost analysis and monitoring
  • Cloud infrastructure automation

Available Methods: Multiple (30+)
  - User and group management
  - Security policy creation
  - Device configuration
  - Access control management
  - License assignment
  - Resource tagging and organization
  - Cost tracking and optimization
  - Compliance auditing

Environment:
  - TENANT_ID loaded from environment
  - CLIENT_ID loaded from environment
  - CLIENT_SECRET loaded from environment
  - LOG_DIR: configured per environment
  - LOG_LEVEL: configured per environment

Authentication: App-only (Client Secret)

EOF

echo "🚀 Starting Lokka Agent..."
echo "   Environment: $ENV"
echo "   Tenant ID: ${TENANT_ID:0:10}..."
echo ""

# Navigate to Lokka MCP server
cd ~/Development/lokka
exec node src/mcp/build/main.js
