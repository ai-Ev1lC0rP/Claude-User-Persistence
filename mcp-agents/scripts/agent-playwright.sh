#!/bin/bash

# Playwright Agent
# Specialized for browser automation, testing, and web interactions
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$PLAYWRIGHT_MCP_KEY" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║          PLAYWRIGHT AGENT - Browser Automation               ║
╚══════════════════════════════════════════════════════════════╝

This agent specializes in:
  • Browser automation and control
  • Web scraping and data extraction
  • Automated testing and validation
  • Screenshot and PDF generation
  • Form filling and interaction
  • JavaScript execution in browser
  • Page navigation and crawling
  • Performance testing and monitoring

Capabilities:
  • Launch and manage browser instances
  • Navigate to URLs and interact with pages
  • Extract content and data from websites
  • Perform automated testing
  • Generate screenshots and PDFs
  • Handle forms and user interactions
  • Execute JavaScript in page context
  • Monitor network requests
  • Record browser sessions

Supported Browsers:
  - Chromium
  - Firefox
  - WebKit (Safari)

Use Cases:
  - Automated testing of web applications
  - Web scraping and data extraction
  - Screenshot and PDF generation
  - Workflow automation involving websites
  - Performance and accessibility testing
  - End-to-end testing

Environment:
  - PLAYWRIGHT_MCP_KEY loaded from environment
  - Runs via @microsoft/playwright-mcp
  - Smithery CLI wrapper
  - Stdio transport for Claude integration

EOF

echo "🚀 Starting Playwright Agent..."
echo "   Environment: $ENV"
echo "   MCP Key: ${PLAYWRIGHT_MCP_KEY:0:10}..."
echo ""

# Execute Playwright MCP via Smithery CLI
# @microsoft/playwright-mcp provides full browser automation via MCP protocol
exec npx -y @smithery/cli@latest run @microsoft/playwright-mcp \
  --key "${PLAYWRIGHT_MCP_KEY:-2589ff8d-323e-4774-82c1-dbcb31d654c5}"
