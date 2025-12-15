#!/bin/bash

# Multi-Agent MCP Orchestrator with Environment Support
# Usage: ./start-all-agents.sh [environment]
# Example: ./start-all-agents.sh local

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV=${1:-local}

cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════╗
║                   MCP MULTI-AGENT ORCHESTRATOR                          ║
║                                                                          ║
║  Starting 3 specialized agents:                                         ║
║  1. NOTION AGENT    - Document management & consolidation               ║
║  2. FIZZY AGENT     - Project management & task tracking                ║
║  3. LOKKA AGENT     - Azure & Microsoft 365 administration              ║
║                                                                          ║
║  Each agent runs independently but can coordinate via shared outputs    ║
╚══════════════════════════════════════════════════════════════════════════╝

EOF

# Load environment
echo "📝 Loading environment: $ENV"
source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
echo ""

# Create log directory
mkdir -p "$LOG_DIR"
echo "📁 Logs directory: $LOG_DIR"
echo ""

# Function to launch agent
launch_agent() {
    local agent_name=$1
    local script_path=$2
    local log_file="$LOG_DIR/${agent_name,,}.log"

    echo "🚀 Launching $agent_name agent..."
    chmod +x "$script_path"
    nohup bash "$script_path" > "$log_file" 2>&1 &
    local pid=$!
    echo "   PID: $pid"
    echo "   Log: $log_file"
    echo ""
    echo "$pid"
}

# Launch all agents with environment
export MCP_ENV=$ENV
export MCP_REPO_ROOT=$REPO_ROOT

NOTION_PID=$(launch_agent "NOTION" "$REPO_ROOT/mcp-agents/scripts/agent-notion.sh")
FIZZY_PID=$(launch_agent "FIZZY" "$REPO_ROOT/mcp-agents/scripts/agent-fizzy.sh")
LOKKA_PID=$(launch_agent "LOKKA" "$REPO_ROOT/mcp-agents/scripts/agent-lokka.sh")
TODO_PID=$(launch_agent "TODO" "$REPO_ROOT/mcp-agents/scripts/agent-todo.sh")
N8N_PID=$(launch_agent "N8N" "$REPO_ROOT/mcp-agents/scripts/agent-n8n.sh")
PLAYWRIGHT_PID=$(launch_agent "PLAYWRIGHT" "$REPO_ROOT/mcp-agents/scripts/agent-playwright.sh")
UNIFI_PID=$(launch_agent "UNIFI" "$REPO_ROOT/mcp-agents/scripts/agent-unifi.sh")

echo "════════════════════════════════════════════════════════════════════════════"
echo ""
echo "✅ All agents started successfully!"
echo ""
echo "Environment: $ENVIRONMENT"
echo "Machine: $MACHINE_NAME"
echo ""
echo "Agent Process IDs:"
echo "  NOTION:     $NOTION_PID"
echo "  FIZZY:      $FIZZY_PID"
echo "  LOKKA:      $LOKKA_PID"
echo "  TODO:       $TODO_PID"
echo "  N8N:        $N8N_PID"
echo "  PLAYWRIGHT: $PLAYWRIGHT_PID"
echo "  UNIFI:      $UNIFI_PID"
echo ""
echo "View logs:"
echo "  tail -f $LOG_DIR/notion.log"
echo "  tail -f $LOG_DIR/fizzy.log"
echo "  tail -f $LOG_DIR/lokka.log"
echo "  tail -f $LOG_DIR/todo.log"
echo "  tail -f $LOG_DIR/n8n.log"
echo "  tail -f $LOG_DIR/playwright.log"
echo "  tail -f $LOG_DIR/unifi.log"
echo ""
echo "View all logs:"
echo "  tail -f $LOG_DIR/*.log"
echo ""
echo "Stop all agents:"
echo "  kill $NOTION_PID $FIZZY_PID $LOKKA_PID $TODO_PID $N8N_PID $PLAYWRIGHT_PID $UNIFI_PID"
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo ""

# Keep script alive and handle signals
trap "echo 'Shutting down agents...'; kill $NOTION_PID $FIZZY_PID $LOKKA_PID $TODO_PID $N8N_PID $PLAYWRIGHT_PID $UNIFI_PID 2>/dev/null; exit" SIGINT SIGTERM

# Wait for agents
wait
