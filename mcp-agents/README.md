# MCP Agents - Multi-Agent Workflow Automation

**Five specialized agents working in parallel with multi-environment support and context persistence.**

---

## 🎯 Overview

This system provides comprehensive automation across your entire workflow:

```
┌──────────────────────────────────────────────────────────────┐
│         MCP AGENTS - COMPREHENSIVE WORKFLOW AUTOMATION       │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│ NOTION    FIZZY      LOKKA       TODO        n8n            │
│ ──────    ─────      ─────       ────        ───            │
│ Docs      Projects   Azure &     Tasks       Workflows      │
│ Pages     Tasks      Microsoft   Management  Automation     │
│ DBs       Teams      365         Scheduling  Integration    │
│                      IT Admin                Data Sync      │
│                                                              │
│ 7         24         30+         n8n MCP     n8n MCP        │
│ handlers  handlers   handlers    Remote      Server         │
│                                                              │
│            Multi-Environment Support (Local/Staging/Prod)   │
│            Context Persistence & Cross-Machine Sync         │
│            Sequential, Parallel & Feedback Loop Workflows   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Start All Agents (Local Environment)

```bash
# Default local environment
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh

# Or specify environment
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh staging
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh production
```

### View Logs

```bash
# All logs
tail -f /tmp/mcp-agents-logs/*.log

# Specific agent
tail -f /tmp/mcp-agents-logs/notion.log
tail -f /tmp/mcp-agents-logs/fizzy.log
tail -f /tmp/mcp-agents-logs/lokka.log
tail -f /tmp/mcp-agents-logs/todo.log
tail -f /tmp/mcp-agents-logs/n8n.log
```

---

## 📚 Agents

### 🔵 NOTION AGENT
**Specialization**: Document management and consolidation

**Capabilities**:
- Parse multiple document formats (PDF, Markdown, CSV, Excel, Text)
- Create Notion pages and databases
- Organize and consolidate information
- Extract metadata and structure
- Build searchable databases

**Methods**: 7
- `parse_document` - Parse any document format
- `create_page` - Create Notion page
- `create_database` - Create Notion database
- `list_pages` - List all pages
- `add_block` - Add content blocks
- `add_database_entry` - Add structured data
- `query_database` - Search and filter data

**Use When**: You need to organize, document, or consolidate information

---

### 🟢 FIZZY AGENT
**Specialization**: Project and task management

**Capabilities**:
- Manage Basecamp boards and projects
- Create and track tasks/cards
- Assign work to team members
- Handle comments and discussions
- Organize with tags and categories

**Methods**: 24
- Board operations (list, get, create, update)
- Card operations (list, get, create, update, close, assign, tag)
- Comment operations (list, create, update, delete)
- Step operations (list, create, update, delete)
- Tag operations (list, apply)
- User operations (list, get)
- Notification operations (list, mark read)
- Identity operations

**Use When**: You need to manage projects, assign tasks, or track work

---

### 🔴 LOKKA AGENT
**Specialization**: Microsoft 365 and Azure administration

**Capabilities**:
- Manage Azure resources
- Administer Entra ID users and groups
- Configure security policies
- Manage device configurations
- Track compliance and licenses

**Methods**: 30+
- User and group management
- Security policy creation
- Device configuration
- Access control management
- License assignment
- Resource tagging
- Cost analysis
- Compliance auditing

**Use When**: You need IT administration, security management, or cloud operations

---

### 🟡 TODO AGENT
**Specialization**: Task and workflow management via n8n

**Capabilities**:
- Create and manage tasks in n8n
- Execute workflows via remote MCP
- Schedule automated tasks
- Manage workflow states
- Track task progress
- Integration with webhook endpoints

**Technology**:
- n8n MCP remote endpoint
- Bearer token authentication
- Webhook-based communication

**Endpoint**:
```
https://n8n.tsargent.work/mcp/32d71f33-6dfd-4ac4-9987-51b14d00f81e
```

**Use When**: You need to create tasks, manage workflows, or schedule automation through n8n

---

### 🟣 n8n MCP AGENT
**Specialization**: Complete workflow automation and system integration

**Capabilities**:
- List and execute n8n workflows
- Manage workflow variables
- Monitor execution status
- Handle errors and retries
- Connect multiple data sources
- Transform and process data
- Schedule automated tasks
- Deep system integration

**Available Methods**:
- Workflow operations (list, get, execute, update)
- Execution monitoring (list, get, retry)
- Variable management (get, set, delete)
- Integration operations
- Data transformation tools

**Technology**:
- n8n-mcp npm package
- Direct API integration
- Stdio transport for Claude

**Configuration**:
```
API URL: https://tsargent.casonclark.com/api/v1
Authentication: API Key (JWT bearer token)
Mode: Stdio for Claude integration
```

**Use When**: You need complex workflow automation, multi-step processes, or deep system integration

---

## 🌍 Multi-Environment Support

Run the same agents across different environments with different configurations:

### Environments
- **Local** (`.env.local`) - Development on your machine
- **Staging** (`.env.staging`) - Pre-production testing
- **Production** (`.env.production`) - Live production

### Start with Specific Environment

```bash
# Local (default)
bash scripts/start-all-agents.sh local

# Staging
bash scripts/start-all-agents.sh staging

# Production
bash scripts/start-all-agents.sh production
```

### Configuration Per Environment

Each environment has:
- Distinct API credentials
- Machine identifier
- Logging level and directory
- Sync interval
- Remote sync enablement

**See**: [MULTI_ENVIRONMENT_SETUP.md](docs/MULTI_ENVIRONMENT_SETUP.md)

---

## 💾 Context Persistence

Agents automatically persist context across sessions and machines:

### What Gets Stored
- **Session Contexts**: Active project information and tasks
- **Agent Outputs**: Results from each operation
- **Machine State**: Per-machine configuration and status
- **Sync Records**: History of cross-machine synchronization
- **Metadata**: Timestamps, versions, checksums

### Automatic Sync
- Agents sync context every `SYNC_INTERVAL` seconds (default: 300)
- Context stored in `mcp-agents/context/`
- Synchronized across machines when `ENABLE_REMOTE_SYNC=true`
- Version controlled in git for history

**See**: [CONTEXT_PERSISTENCE.md](docs/CONTEXT_PERSISTENCE.md)

---

## 🔄 Agent Coordination

Agents work independently but can coordinate:

### Coordination Patterns

**Sequential**: One agent's output feeds into another
```
Lokka (Query Users) → Fizzy (Assign Cards) → Notion (Document)
```

**Parallel**: Multiple agents work simultaneously
```
         → Fizzy (Get Tasks)
Coordinator
         → Lokka (Get Team)
              ↓ (merge)
         → Notion (Consolidate)
```

**Feedback Loop**: Changes propagate through agents
```
Notion → Fizzy → Lokka → (back to Notion)
```

**See**: [AGENT_COORDINATION.md](docs/AGENT_COORDINATION.md) (one level up)

---

## 📁 Directory Structure

```
mcp-agents/
├── README.md                          # This file
├── environments/                      # Multi-environment configs
│   ├── .env.template
│   ├── .env.local
│   ├── .env.staging
│   └── .env.production
├── configs/                           # Agent configurations
│   ├── notion-config.json
│   ├── fizzy-config.json
│   └── lokka-config.json
├── scripts/                           # Agent launch scripts
│   ├── load-environment.sh           # Load env variables
│   ├── start-all-agents.sh           # Launch all agents
│   ├── agent-notion.sh               # Notion agent launcher
│   ├── agent-fizzy.sh                # Fizzy agent launcher
│   └── agent-lokka.sh                # Lokka agent launcher
├── context/                           # Persisted context
│   ├── sessions/                     # Session contexts
│   ├── machines/                     # Per-machine state
│   ├── outputs/                      # Agent outputs
│   ├── syncs/                        # Sync records
│   └── index.json                    # Context index
└── docs/                              # Documentation
    ├── MULTI_ENVIRONMENT_SETUP.md    # Environment guide
    ├── CONTEXT_PERSISTENCE.md        # Context strategy
    └── README.md                     # This directory
```

---

## 🔐 Security & Credentials

### Local Development
All credentials stored in `~/.zshrc`:
```bash
export NOTION_API_TOKEN=ntn_...
export FIZZY_API_KEY=...
export TENANT_ID=...
export CLIENT_ID=...
export CLIENT_SECRET=...
```

### Multi-Environment
Each environment has separate credentials in:
- `.env.local` - Local development
- `.env.staging` - Staging credentials
- `.env.production` - Production credentials (never commit with real values)

### Best Practices
1. Never commit real credentials to git
2. Use environment variable injection in CI/CD
3. Rotate credentials regularly
4. Keep `.env.production` encrypted
5. Audit all credential access

---

## 📊 Common Workflows

### 1. New Team Onboarding
```
Lokka: Create user in Entra ID
  ↓
Fizzy: Create team board, assign tasks
  ↓
Notion: Document structure, create checklist
```

### 2. Project Status Report
```
Fizzy: Get all project cards/tasks
  ↓
Lokka: Get team members and assignments
  ↓
Notion: Consolidate into status document
```

### 3. IT Compliance Audit
```
Lokka: Query security policies, device configs
  ↓
Notion: Document current state, create report
  ↓
Fizzy: Create remediation tasks
```

### 4. Department Reorganization
```
Lokka: Create new security groups
  ↓
Fizzy: Create project boards for each group
  ↓
Notion: Document org structure
```

---

## 🛠️ Manual Startup

Start agents in separate terminal sessions:

```bash
# Terminal 1: Notion Agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-notion.sh

# Terminal 2: Fizzy Agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-fizzy.sh

# Terminal 3: Lokka Agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-lokka.sh

# Terminal 4: Todo Agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-todo.sh

# Terminal 5: n8n Agent
source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/agent-n8n.sh
```

All five agents run independently and communicate via MCP protocol.

---

## 📖 Documentation

### Quick References
- [Multi-Environment Setup](docs/MULTI_ENVIRONMENT_SETUP.md) - Configure for different environments
- [Context Persistence](docs/CONTEXT_PERSISTENCE.md) - How context is stored and synchronized
- [Agent Coordination](../AGENT_COORDINATION.md) - Coordination patterns and workflows

### Configuration
- `.env.template` - All available environment variables
- `configs/` - Agent-specific configurations
- `environments/` - Environment-specific settings

### Resources
- [Main Repository README](../README.md)
- [Context Sync Skill](../skills/context-sync/SKILL.md)

---

## 🔍 Monitoring

### View All Logs
```bash
tail -f /tmp/mcp-agents-logs/*.log
```

### Check Agent Status
```bash
# List running agents
ps aux | grep "agent-"

# Count active agents
pgrep -f "agent-" | wc -l

# Get agent PIDs
pgrep -f "agent-" -a
```

### Stop Agents
```bash
# Stop all agents
pkill -f "agent-"

# Or kill specific PIDs
kill <pid1> <pid2> <pid3>
```

---

## ⚙️ Configuration

### Environment Variables

Create `.env.local`, `.env.staging`, or `.env.production` with:

```bash
# API Credentials
NOTION_API_TOKEN=your_token
FIZZY_API_KEY=your_key
TENANT_ID=your_tenant
CLIENT_ID=your_client_id
CLIENT_SECRET=your_secret

# Environment Settings
ENVIRONMENT=local|staging|production
MACHINE_NAME=your_machine_name

# Logging
LOG_LEVEL=debug|info|warn|error
LOG_DIR=/path/to/logs

# Sync
SYNC_INTERVAL=300
ENABLE_REMOTE_SYNC=true|false
```

**See**: [MULTI_ENVIRONMENT_SETUP.md](docs/MULTI_ENVIRONMENT_SETUP.md) for details

---

## ✨ Features

✅ **NOTION AGENT**
- Multi-format document parsing
- Database management
- Page organization
- Content consolidation

✅ **FIZZY AGENT**
- Project and task management
- Team collaboration
- Progress tracking
- Comment handling

✅ **LOKKA AGENT**
- Azure and M365 administration
- Security and compliance
- IT operations
- User and group management

✅ **TODO AGENT (n8n MCP Remote)**
- Task creation and management
- Workflow execution via n8n
- Task scheduling and automation
- Webhook-based integration
- Real-time task tracking

✅ **n8n MCP AGENT**
- Complete workflow automation
- Multi-step process orchestration
- Data transformation and mapping
- Deep system integration
- Error handling and retries
- Scheduled task execution

✅ **COORDINATION**
- Sequential workflows
- Parallel execution
- Feedback loops
- Output sharing
- n8n integration

✅ **MULTI-ENVIRONMENT**
- Local, staging, production support
- Per-environment credentials
- Machine-specific configuration
- Context synchronization

✅ **CONTEXT PERSISTENCE**
- Automatic session saving
- Cross-machine sync
- Context compaction
- Version control

---

## 🚀 Getting Started

1. **Verify Environment Setup**
   ```bash
   source ~/Development/Claude-User-Persistence/mcp-agents/scripts/load-environment.sh local
   echo $NOTION_API_TOKEN
   ```

2. **Start All Agents**
   ```bash
   bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh
   ```

3. **Monitor Agents**
   ```bash
   tail -f /tmp/mcp-agents-logs/*.log
   ```

4. **Use Agents in Claude Sessions**
   - Agents are now available as MCP tools
   - Query them in natural language
   - Coordinate between agents
   - Context is automatically persisted

---

## 🎯 Design Principles

1. **Specialization**: Each agent has a specific domain
2. **Independence**: Agents work without depending on each other
3. **Coordination**: Agents can work together when needed
4. **Parallelism**: Multiple agents run simultaneously
5. **Persistence**: Context automatically saved and synchronized
6. **Scalability**: Easy to deploy across different environments
7. **Security**: Credentials managed per environment
8. **Observability**: Full logging and monitoring

---

## 📞 Quick Commands

| Command | Purpose |
|---------|---------|
| `bash scripts/start-all-agents.sh local` | Start all agents (local) |
| `bash scripts/start-all-agents.sh staging` | Start all agents (staging) |
| `bash scripts/start-all-agents.sh production` | Start all agents (production) |
| `source scripts/load-environment.sh local` | Load environment variables |
| `bash scripts/agent-notion.sh` | Start Notion agent |
| `bash scripts/agent-fizzy.sh` | Start Fizzy agent |
| `bash scripts/agent-lokka.sh` | Start Lokka agent |
| `bash scripts/agent-todo.sh` | Start toDo agent |
| `bash scripts/agent-n8n.sh` | Start n8n MCP agent |
| `pkill -f agent-` | Stop all agents |
| `tail -f /tmp/mcp-agents-logs/*.log` | View all logs |
| `ps aux \| grep agent-` | Check running agents |

---

## 🎉 You're Ready!

Five specialized agents with multi-environment support, context persistence, and full coordination capabilities.

**61+ total handlers** across all agents providing comprehensive workflow automation.

**Start your automation platform:**
```bash
bash ~/Development/Claude-User-Persistence/mcp-agents/scripts/start-all-agents.sh
```

---

**Last Updated**: December 14, 2025
**Version**: 2.0.0 (Added n8n agents)
**Status**: ✅ Ready for Production
