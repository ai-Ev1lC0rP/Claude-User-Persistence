#!/bin/bash

# Load appropriate environment configuration
# Usage: source load-environment.sh [environment]
# Example: source load-environment.sh local

set -e

# Determine environment
ENV=${1:-local}
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENV_FILE="$REPO_ROOT/mcp-agents/environments/.env.$ENV"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Environment file not found: $ENV_FILE"
  echo "   Available environments: local, staging, production"
  echo "   Usage: source load-environment.sh [environment]"
  return 1 2>/dev/null || exit 1
fi

echo "📝 Loading environment: $ENV"
export $(cat "$ENV_FILE" | grep -v '^#' | grep -v '^$' | xargs)

echo "✅ Environment loaded"
echo "   Repo: $REPO_ROOT"
echo "   Environment: ${ENVIRONMENT}"
echo "   Machine: ${MACHINE_NAME}"
echo "   Log Dir: ${LOG_DIR}"
