#!/bin/bash

# UniFi Network Agent
# Specialized for network management and monitoring
# Loads environment from MCP_ENV variable or defaults to local

REPO_ROOT="${MCP_REPO_ROOT:-.}"
SCRIPTS_DIR="$REPO_ROOT/mcp-agents/scripts"
ENV="${MCP_ENV:-local}"

# Load environment if not already loaded
if [ -z "$UNIFI_HOST" ]; then
  source "$SCRIPTS_DIR/load-environment.sh" "$ENV" || exit 1
fi

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║           UNIFI NETWORK AGENT - Network Management           ║
╚══════════════════════════════════════════════════════════════╝

This agent specializes in:
  • UniFi network controller management
  • Network device monitoring and control
  • WiFi network configuration
  • Client/user device management
  • Network statistics and analytics
  • Firewall and security policy management
  • VPN configuration and monitoring
  • Network performance monitoring
  • Device grouping and management

Capabilities:
  • List and manage network devices (APs, switches, gateways)
  • View and manage connected clients
  • Monitor network statistics and performance
  • Configure WiFi networks and security
  • Manage user groups and permissions
  • Block/allow clients and devices
  • Configure port forwarding and VLANs
  • Monitor network health
  • Generate network reports
  • Manage UniFi cloud access

Network Objects Managed:
  - Access Points (APs)
  - Switches
  - Gateways
  - Clients/Devices
  - Networks (SSID)
  - VLANs
  - Firewall rules
  - User accounts

Environment:
  - UNIFI_HOST loaded from environment
  - UNIFI_USERNAME loaded from environment
  - UNIFI_PASSWORD loaded from environment
  - UNIFI_PORT loaded from environment
  - UNIFI_SITE loaded from environment
  - UNIFI_VERIFY_SSL loaded from environment
  - CONFIG_PATH loaded from environment

Connection:
  - Direct to UniFi Network Controller
  - Local Python-based MCP server
  - Stdio transport for Claude integration

EOF

echo "🚀 Starting UniFi Network Agent..."
echo "   Environment: $ENV"
echo "   Host: ${UNIFI_HOST}"
echo "   Site: ${UNIFI_SITE:-default}"
echo "   User: ${UNIFI_USERNAME}"
echo ""

# Execute UniFi Network MCP server
# Custom Python MCP server for UniFi controller interaction
exec "${UNIFI_MCP_SERVER:-/Users/casonclark/Development/unifi-network-mcp/.venv/bin/unifi-network-mcp}"
