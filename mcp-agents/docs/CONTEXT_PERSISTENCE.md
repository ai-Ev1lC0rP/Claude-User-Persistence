# Context Persistence Strategy

This document outlines how agent context, outputs, and state are stored and retrieved across sessions and environments.

## 🎯 Objectives

1. **Session Continuity**: Resume work in new sessions without re-establishing context
2. **Multi-Machine Sync**: Synchronize context across different machines and environments
3. **Context Compaction**: Gradually compact and optimize context over time
4. **Historical Preservation**: Maintain version history of context snapshots
5. **Environment Isolation**: Keep environment-specific contexts separate

## 📁 Context Storage Structure

```
mcp-agents/context/
├── sessions/                          # Active session contexts
│   ├── session-2025-12-14-001.json
│   ├── session-2025-12-14-002.json
│   └── current.json                  # Latest active session
├── machines/                          # Per-machine state
│   ├── casonclark-macbook/
│   │   ├── state.json
│   │   ├── last-sync.json
│   │   └── environment.json
│   └── staging-server/
│       ├── state.json
│       ├── last-sync.json
│       └── environment.json
├── outputs/                           # Agent outputs
│   ├── notion-outputs/
│   │   ├── 2025-12-14/
│   │   │   ├── parsed-documents.json
│   │   │   ├── created-pages.json
│   │   │   └── database-entries.json
│   │   └── latest/
│   ├── fizzy-outputs/
│   │   ├── 2025-12-14/
│   │   │   ├── boards.json
│   │   │   ├── cards.json
│   │   │   └── assignments.json
│   │   └── latest/
│   └── lokka-outputs/
│       ├── 2025-12-14/
│       │   ├── security-groups.json
│       │   ├── policies.json
│       │   └── users.json
│       └── latest/
├── syncs/                             # Synchronization records
│   ├── 2025-12-14/
│   │   ├── sync-001.json             # Sync from local to remote
│   │   ├── sync-002.json
│   │   └── sync-conflicts.json       # Any conflicts detected
│   └── summary.json                  # Sync history summary
└── index.json                         # Master index of all contexts
```

## 📋 Context Schema

### Session Context (session-*.json)

```json
{
  "id": "session-2025-12-14-001",
  "timestamp": "2025-12-14T10:30:45.000Z",
  "environment": "local",
  "machine": "casonclark-macbook",
  "duration_seconds": 3600,
  "status": "active|completed|archived",
  "agents": {
    "notion": {
      "status": "running|idle|error",
      "tasks_completed": 5,
      "documents_parsed": 3,
      "pages_created": 2,
      "last_action": "2025-12-14T10:35:00.000Z"
    },
    "fizzy": {
      "status": "running|idle|error",
      "tasks_completed": 12,
      "cards_created": 4,
      "boards_accessed": 2,
      "last_action": "2025-12-14T10:34:55.000Z"
    },
    "lokka": {
      "status": "running|idle|error",
      "tasks_completed": 3,
      "groups_created": 1,
      "policies_updated": 2,
      "last_action": "2025-12-14T10:34:50.000Z"
    }
  },
  "context_summary": {
    "total_actions": 20,
    "errors": 0,
    "warnings": 1,
    "api_calls": 45
  },
  "tags": ["onboarding", "project-setup"],
  "notes": "Setting up new team infrastructure"
}
```

### Machine State (machines/*/state.json)

```json
{
  "machine_name": "casonclark-macbook",
  "machine_id": "abc123def456",
  "environment": "local",
  "last_active": "2025-12-14T10:35:00.000Z",
  "agent_pids": {
    "notion": 12345,
    "fizzy": 12346,
    "lokka": 12347
  },
  "uptime_seconds": 7200,
  "context_loaded": true,
  "current_session": "session-2025-12-14-001",
  "disk_space_mb": 5120,
  "memory_mb": 512,
  "cpu_percent": 15.5
}
```

### Agent Output (outputs/*/2025-12-14/*.json)

```json
{
  "timestamp": "2025-12-14T10:35:00.000Z",
  "agent": "notion",
  "action": "parse_document",
  "status": "success|error",
  "input": {
    "file": "document.pdf",
    "format": "pdf"
  },
  "output": {
    "pages": 10,
    "tables": 2,
    "text_length": 5200,
    "extracted_metadata": {
      "title": "Project Charter",
      "author": "John Doe",
      "created": "2025-01-15"
    }
  },
  "duration_ms": 250,
  "errors": null
}
```

### Sync Record (syncs/2025-12-14/sync-001.json)

```json
{
  "sync_id": "sync-001",
  "timestamp": "2025-12-14T10:40:00.000Z",
  "source_machine": "casonclark-macbook",
  "target_machine": "staging-server",
  "direction": "push|pull",
  "items_synced": {
    "sessions": 2,
    "outputs": 15,
    "state_updates": 3
  },
  "conflicts": [],
  "duration_ms": 1200,
  "status": "success|partial|failed",
  "checksum": "abc123def456"
}
```

## 🔄 Context Lifecycle

### 1. Context Creation
```
New Session Started
    ↓
Load Environment Config
    ↓
Initialize Session Context
    ↓
Create session-*.json
    ↓
Link to current.json
```

### 2. Context Updates
```
Agent Action Completed
    ↓
Log to outputs/{agent}/latest/
    ↓
Update session context (tasks_completed, etc.)
    ↓
Record timestamp in machine state
    ↓
Check if sync needed (SYNC_INTERVAL)
```

### 3. Context Sync
```
Sync Interval Reached
    ↓
Gather all outputs since last sync
    ↓
Check machine state compatibility
    ↓
Detect conflicts
    ↓
Push/Pull context
    ↓
Record sync metadata
    ↓
Archive old outputs to dated directory
```

### 4. Context Archival
```
Session Complete
    ↓
Move session to archived/
    ↓
Compact context (remove verbose logs)
    ↓
Generate summary
    ↓
Commit to git
```

## 🗜️ Context Compaction Strategy

### Phase 1: Immediate (After Each Action)
- Keep full detail in `latest/` directory
- Move to dated directories after 1 day
- Keep timestamps for all items

### Phase 2: Daily (Overnight)
- Compress verbose logs
- Extract summaries from detailed outputs
- Remove debug information
- Keep only essential metadata

### Phase 3: Weekly (Sunday)
- Archive old dated directories
- Consolidate into weekly summaries
- Generate usage statistics
- Clean up temporary files

### Phase 4: Monthly (1st of Month)
- Archive weekly summaries
- Generate monthly reports
- Analyze trends
- Plan optimization

## 🔗 Context Integration Points

### With Claude User Persistence
```
MCP Agents Context
    ↓
Stored in: mcp-agents/context/
    ↓
Synced to: Claude User Persistence central repo
    ↓
Persisted in: Azure Blob Storage / Supabase
    ↓
Retrieved in: New sessions across any machine
```

### With Agent Coordination
```
Agent A Output
    ↓
Stored in: outputs/agent-a/latest/
    ↓
Consumed by: Agent B
    ↓
Referenced in: outputs/agent-b/latest/
    ↓
Stored with cross-reference
```

## 🚀 Usage Patterns

### Pattern 1: Resume Session
```bash
# Check available sessions
cat mcp-agents/context/index.json

# Load previous session
source mcp-agents/context/sessions/session-2025-12-14-001.json

# Continue work with full context
bash mcp-agents/scripts/start-all-agents.sh
```

### Pattern 2: Sync Across Machines
```bash
# On source machine (local)
bash mcp-agents/scripts/start-all-agents.sh local

# Automatically syncs if ENABLE_REMOTE_SYNC=true
# Checks every SYNC_INTERVAL seconds

# On target machine (staging)
bash mcp-agents/scripts/start-all-agents.sh staging

# Pulls latest context on startup
```

### Pattern 3: Context Analysis
```bash
# Generate context report
cat mcp-agents/context/syncs/summary.json

# See top actions by agent
grep -r "action" mcp-agents/context/outputs/ | wc -l

# Find all successful operations
grep '"status": "success"' mcp-agents/context/outputs/*/*.json
```

## 📊 Context Metrics

Each session tracks:
- **Total Actions**: Sum of all agent operations
- **Success Rate**: (Successful / Total) * 100
- **Average Duration**: Mean time per action
- **Document Parsed**: Count of parsed documents
- **Pages Created**: Notion pages created
- **Cards Created**: Fizzy cards created
- **Groups Created**: Lokka groups created
- **Errors**: Total error count
- **API Calls**: Total API calls made

## 🔐 Security & Privacy

### Context Encryption
```bash
# Sensitive data in context files
# Consider encrypting:
# - API responses with credentials
# - User/Group information
# - Security policies
# - Audit logs
```

### Access Control
```bash
# File permissions
# mcp-agents/context/ should be readable only by owner
chmod 700 mcp-agents/context/

# .env files should never be readable by others
chmod 600 mcp-agents/environments/.env.*
```

### Audit Trail
```bash
# All sync operations logged
# All context changes tracked
# All access recorded in syncs/
```

## 🔄 Sync Conflict Resolution

### Conflict Types
1. **Timestamp Conflict**: Same item updated in multiple machines
2. **Content Conflict**: Different changes to same item
3. **Dependency Conflict**: Output from one agent conflicts with another

### Resolution Strategy
1. **Automatic**: Latest timestamp wins
2. **Manual Review**: Conflicts recorded in sync-conflicts.json
3. **Merge**: Combine compatible changes
4. **Rollback**: Revert to last known good state

## 📚 Related Documentation

- [MULTI_ENVIRONMENT_SETUP.md](./MULTI_ENVIRONMENT_SETUP.md) - Environment configuration
- [AGENT_COORDINATION.md](./AGENT_COORDINATION.md) - Agent coordination patterns
- [../../README.md](../../README.md) - Main project documentation

---

**Last Updated**: December 14, 2025
**Context Persistence Version**: 1.0.0
