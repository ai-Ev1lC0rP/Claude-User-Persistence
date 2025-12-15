# Multi-Environment MCP Agents Setup

This guide explains how to use the multi-environment configuration system to run MCP agents across local, staging, and production environments.

## 📋 Overview

The Claude User Persistence MCP agents system supports multiple environments with distinct configurations:

- **Local**: Development environment on your machine
- **Staging**: Pre-production testing environment
- **Production**: Live production environment

Each environment has its own:
- API credentials
- Machine identifiers
- Logging configuration
- Sync intervals and settings
- Remote sync enablement

## 🗂️ Environment Files

All environment configurations are stored in `mcp-agents/environments/`:

```
mcp-agents/environments/
├── .env.template          # Template with all available options
├── .env.local             # Local development (default)
├── .env.staging           # Staging environment
└── .env.production        # Production environment
```

### Environment Variables Reference

| Variable | Purpose | Default |
|----------|---------|---------|
| `NOTION_API_TOKEN` | Notion API authentication | Required |
| `FIZZY_API_KEY` | Fizzy/Basecamp API key | Required |
| `TENANT_ID` | Microsoft tenant ID | Required |
| `CLIENT_ID` | Azure app client ID | Required |
| `CLIENT_SECRET` | Azure app client secret | Required |
| `ENVIRONMENT` | Environment name (local/staging/production) | Required |
| `MACHINE_NAME` | Identifier for this machine | $(hostname) |
| `LOG_LEVEL` | Logging verbosity (debug/info/warn/error) | info |
| `LOG_DIR` | Directory for agent logs | /tmp/mcp-agents-logs |
| `SYNC_INTERVAL` | Context sync frequency (seconds) | 300 |
| `MAX_CONTEXT_SIZE` | Maximum context size (bytes) | 10485760 |
| `ENABLE_REMOTE_SYNC` | Sync context across machines | true |

## 🚀 Starting Agents

### Option 1: Start All Agents (Recommended)

```bash
# Start with default local environment
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh

# Start with specific environment
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh staging
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh production
```

### Option 2: Start Individual Agents

```bash
# Load environment first
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local

# Start specific agent
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-notion.sh
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-fizzy.sh
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-lokka.sh
```

### Option 3: Start in Separate Terminals

```bash
# Terminal 1: Load environment and start Notion agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-notion.sh

# Terminal 2: Load environment and start Fizzy agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-fizzy.sh

# Terminal 3: Load environment and start Lokka agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-lokka.sh
```

## 📝 Configuring Environments

### Local Environment (.env.local)

Used for development on your machine. Already configured with your credentials.

```bash
# View current local config
cat ~/Development/Claude-User-Persistence/mcp-agents/environments/.env.local

# No changes needed if already configured
```

### Staging Environment (.env.staging)

Used for testing before production. Copy the template and add staging credentials:

```bash
# View and edit staging config
nano ~/Development/Claude-User-Persistence/mcp-agents/environments/.env.staging
```

Update these values:
- `NOTION_API_TOKEN=` - Staging Notion workspace token
- `FIZZY_API_KEY=` - Staging Fizzy API key
- `TENANT_ID=` - Staging Azure tenant ID
- `CLIENT_ID=` - Staging Azure app client ID
- `CLIENT_SECRET=` - Staging Azure app client secret
- `MACHINE_NAME=staging-server` - Identifier for staging machine
- `LOG_LEVEL=info` - Info level for staging

### Production Environment (.env.production)

Used for live production. Extra caution with credentials:

```bash
# Edit production config (never commit with real credentials!)
nano ~/Development/Claude-User-Persistence/mcp-agents/environments/.env.production
```

**Security Notes**:
1. Never commit `.env.production` with real credentials
2. Use environment variable injection in CI/CD pipelines
3. Rotate credentials regularly
4. Audit access logs

## 🔄 Multi-Machine Setup

### Scenario: Development on Multiple Machines

Machine 1 (MacBook - Local Dev):
```bash
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh local
```

Machine 2 (Linux Server - Staging):
```bash
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh staging
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh staging
```

Machine 3 (Cloud VM - Production):
```bash
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh production
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh production
```

Each machine will:
- Load its specific environment configuration
- Identify itself with `MACHINE_NAME` and `MACHINE_ID`
- Store logs in environment-specified directory
- Sync context at configured interval if `ENABLE_REMOTE_SYNC=true`

## 📊 Monitoring Agents by Environment

### View Logs for Current Environment

```bash
# After starting agents with environment
tail -f $LOG_DIR/*.log

# Or view specific agent
tail -f $LOG_DIR/notion.log
tail -f $LOG_DIR/fizzy.log
tail -f $LOG_DIR/lokka.log
```

### Check Agent Status

```bash
# List running agents
ps aux | grep "agent-"

# Count active agents
pgrep -f "agent-" | wc -l
```

### Stop Agents

```bash
# Stop all agents
pkill -f "agent-"

# Or kill specific PIDs
kill <notion_pid> <fizzy_pid> <lokka_pid>
```

## 🔐 Security Best Practices

### Local Development

```bash
# Store credentials in ~/.zshrc (already done)
# Load from environment file for validation
source mcp-agents/scripts/load-environment.sh local
```

### Staging & Production

```bash
# NEVER commit real credentials to git
# Use environment variable injection:

# 1. Inject via shell environment before startup
export NOTION_API_TOKEN="staging_token"
export FIZZY_API_KEY="staging_key"
bash start-all-agents.sh staging

# 2. Or use CI/CD secrets management
# 3. Or use external secret vault (AWS Secrets Manager, Azure Key Vault, etc.)
```

### Credential Rotation

```bash
# When rotating credentials:
1. Update .env.local/staging/production with new values
2. Test with single agent first
3. Verify all agents connect successfully
4. Update ~/.zshrc for local dev
5. Restart all agents
6. Verify logs show successful connections
```

## 🔗 Integration with Claude User Persistence

The MCP agents system integrates with Claude User Persistence for:

1. **Context Sync**: Agent outputs stored in `mcp-agents/context/`
2. **Configuration Persistence**: Environment configs stored in `mcp-agents/environments/`
3. **Multi-Machine Sync**: Context synchronized across machines when enabled
4. **Version Control**: All configs committed to git for history

## 📚 Related Documentation

- [AGENT_COORDINATION.md](../AGENT_COORDINATION.md) - Agent coordination patterns
- [Multi-Agent System README](../README.md) - Quick start guide
- [Context Sync Skill](../../skills/context-sync/SKILL.md) - Context persistence documentation
- [Main Repository README](../../README.md) - Overall project documentation

## ❓ Troubleshooting

### Environment Variables Not Loading

```bash
# Verify environment file exists
ls -la ~/Development/Claude-User-Persistence/mcp-agents/environments/.env.local

# Test environment loading
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
echo $NOTION_API_TOKEN  # Should show token
```

### Agent Fails to Start

```bash
# Check logs for error
tail -f /tmp/mcp-agents-logs/notion.log

# Verify API credentials
echo "NOTION_API_TOKEN: $NOTION_API_TOKEN"
echo "FIZZY_API_KEY: $FIZZY_API_KEY"

# Verify MCP server location
ls -la ~/Development/notion-mcp-server/dist/index.js
```

### Sync Issues Between Machines

```bash
# Verify ENABLE_REMOTE_SYNC setting
grep ENABLE_REMOTE_SYNC ~/.env.local

# Check network connectivity
ping <remote_machine>

# Verify context files accessible
ls -la mcp-agents/context/
```

## 🔄 Next Steps

1. **Test Local Environment**: Run `start-all-agents.sh local` and verify all agents start
2. **Configure Staging**: Update `.env.staging` with staging credentials
3. **Configure Production**: Update `.env.production` with production credentials
4. **Test Multi-Machine**: Deploy to staging/production and verify context sync
5. **Set Up Monitoring**: Configure log aggregation and alerting

---

**Last Updated**: December 14, 2025
**Environment System Version**: 1.0.0
