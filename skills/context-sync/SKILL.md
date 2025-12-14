# Context Sync Skill

A Claude Code skill for synchronizing session context, tools, and preferences across multiple machines and environments.

## Overview

The Context Sync skill enables seamless continuity of Claude sessions by automatically detecting, storing, and synchronizing context information. This eliminates the need to recreate project context, reconfigure tools, or lose conversation history when switching between machines or starting new sessions.

## Skill Capabilities

### Core Functions
- **Context Detection**: Automatically identify active projects, tools, and session state
- **Bidirectional Sync**: Push local changes and pull remote updates
- **Conflict Resolution**: Handle concurrent modifications across multiple machines
- **State Management**: Maintain consistency of tools, preferences, and active contexts

### Tool Integration
- **MCP Server Registration**: Track and sync MCP server configurations
- **Skill Management**: Synchronize custom skills and their configurations
- **Tool State**: Preserve tool preferences and active configurations
- **Environment Mapping**: Handle machine-specific paths and settings

## Usage Patterns

### Automatic Activation
The skill activates automatically when:
- Starting a new Claude session
- Switching to a new project directory
- Detecting changes in tool configurations
- Receiving sync notifications from other machines

### Manual Triggers
```bash
# Pull latest context from remote
claude-sync pull

# Push current context to remote
claude-sync push

# View sync status and conflicts
claude-sync status

# Resolve conflicts interactively
claude-sync resolve
```

## Configuration

### Skill Configuration (`skills/context-sync/config.json`)
```json
{
  "sync_endpoint": "https://n8n.casonclark.com/webhook/context-sync",
  "machine_id": "auto-generated-uuid",
  "sync_interval": 300,
  "auto_sync": true,
  "conflict_resolution": "interactive",
  "privacy_mode": false,
  "excluded_patterns": [
    "*.env",
    "*.key",
    "**/node_modules/**",
    "**/.git/**"
  ]
}
```

### Environment Variables
```bash
CLAUDE_SYNC_ENDPOINT=https://n8n.casonclark.com/webhook/context-sync
CLAUDE_MACHINE_ID=auto-generated-uuid
CLAUDE_SYNC_TOKEN=your-sync-token
CLAUDE_PRIVACY_MODE=false
```

## File Structure

```
skills/context-sync/
├── SKILL.md                    # This file
├── config.json                 # Skill configuration
├── scripts/
│   ├── init_sync.py            # Initialize synchronization
│   ├── pull_context.py         # Pull remote context
│   ├── push_context.py         # Push local context
│   ├── diff_context.py         # Compare local vs remote
│   ├── resolve_conflicts.py    # Handle conflicts
│   └── monitor_changes.py      # Watch for changes
├── references/
│   ├── schema.md              # Schema documentation
│   ├── mcp-registry.md        # MCP server registry
│   └── skill-manifest.md      # Skill inventory
└── assets/
    └── templates/             # Context templates
        ├── project-context.json
        ├── session-state.json
        └── tool-config.json
```

## Script Documentation

### init_sync.py
Initializes synchronization for a new machine or project.

**Usage:**
```bash
python scripts/init_sync.py [--machine-id ID] [--force]
```

**Functions:**
- Generate unique machine identifier
- Set up local sync configuration
- Create initial context document
- Register with central sync service

### pull_context.py
Retrieves and applies remote context updates.

**Usage:**
```bash
python scripts/pull_context.py [--dry-run] [--context-id ID] [--force]
```

**Functions:**
- Fetch latest context from remote
- Compare with local state
- Apply changes with conflict detection
- Update local context documents

### push_context.py
Uploads local context changes to remote storage.

**Usage:**
```bash
python scripts/push_context.py [--dry-run] [--include-session] [--force]
```

**Functions:**
- Collect local context changes
- Generate change delta
- Upload to remote storage
- Update sync metadata

### diff_context.py
Compares local and remote context states.

**Usage:**
```bash
python scripts/diff_context.py [--format json|text] [--path PATH]
```

**Functions:**
- Fetch remote context
- Compare with local state
- Display differences
- Identify potential conflicts

### resolve_conflicts.py
Handles conflict resolution during synchronization.

**Usage:**
```bash
python scripts/resolve_conflicts.py [--strategy local|remote|interactive]
```

**Functions:**
- Detect conflicting changes
- Present resolution options
- Apply resolution strategy
- Update conflict metadata

## Context Types

### Session Context
- Current project information
- Active file paths and bookmarks
- Conversation summary and key decisions
- Current tasks and their status

### Tool Context
- Active MCP servers and their status
- Skill configurations and preferences
- Tool usage patterns and frequencies
- Environment-specific settings

### Project Context
- Repository information and branch state
- Build configurations and dependencies
- Environment variables (non-sensitive)
- Project-specific preferences

### User Preferences
- Response style preferences
- Code style and conventions
- Workflow patterns and shortcuts
- Privacy and security settings

## Synchronization Flow

### Push Flow
1. **Change Detection**: Monitor file system and tool state for changes
2. **Context Collection**: Gather relevant context information
3. **Validation**: Validate against schema and security policies
4. **Conflict Check**: Compare with remote state for conflicts
5. **Upload**: Send changes to central storage
6. **Confirmation**: Verify successful upload and update metadata

### Pull Flow
1. **Status Check**: Query remote for available updates
2. **Change Retrieval**: Download new or modified context
3. **Conflict Detection**: Compare with local state
4. **Resolution**: Apply automatic or manual conflict resolution
5. **Application**: Update local context and tool configurations
6. **Verification**: Confirm successful application

### Conflict Resolution Strategies

#### Automatic Resolution
- **Last Writer Wins**: Use most recent timestamp
- **Machine Priority**: Give precedence to specific machines
- **Content Merging**: Automatically merge non-conflicting changes
- **Type-Specific**: Apply different strategies per data type

#### Interactive Resolution
- **Side-by-Side Comparison**: Show local vs remote values
- **Contextual Information**: Display relevant metadata
- **Guided Choices**: Provide resolution recommendations
- **Preview Changes**: Show impact of resolution choices

## Security and Privacy

### Data Protection
- **Credential Filtering**: Automatically exclude sensitive information
- **Encryption**: Encrypt data in transit and at rest
- **Access Control**: Machine-based authentication and authorization
- **Audit Logging**: Track all sync operations and access

### Privacy Controls
- **Privacy Mode**: Exclude personally identifiable information
- **Selective Sync**: Choose which context types to synchronize
- **Local Override**: Keep sensitive configurations local-only
- **Data Retention**: Configurable retention periods

## Error Handling

### Common Error Scenarios
- **Network Connectivity**: Handle offline scenarios gracefully
- **Schema Validation**: Provide clear error messages for invalid data
- **Storage Limits**: Manage storage quotas and cleanup
- **Concurrent Access**: Handle multiple machines syncing simultaneously

### Recovery Mechanisms
- **Retry Logic**: Exponential backoff for transient failures
- **Rollback**: Ability to revert to previous known good state
- **Partial Sync**: Continue with available data when some fails
- **Manual Recovery**: Tools for diagnosing and fixing sync issues

## Integration Points

### n8n Workflow Integration
- RESTful API endpoints for CRUD operations
- Webhook notifications for real-time updates
- Batch operations for efficient bulk synchronization
- Health monitoring and alerting

### MCP Server Integration
- Native tool registration and status tracking
- Automatic discovery of new MCP servers
- Configuration synchronization across machines
- Error state handling and recovery

### Claude Desktop Integration
- Session state preservation across restarts
- Automatic context restoration on startup
- Tool availability synchronization
- Preference propagation

## Performance Considerations

### Optimization Strategies
- **Delta Synchronization**: Only transfer changed data
- **Compression**: Reduce bandwidth usage with compression
- **Caching**: Local caching for frequently accessed data
- **Batching**: Group operations for efficiency

### Scalability Limits
- **Context Size**: Maximum context document size limits
- **Sync Frequency**: Rate limiting to prevent excessive API calls
- **Storage Quotas**: Per-user storage limits and cleanup policies
- **Concurrent Sessions**: Maximum number of active sessions per user

## Monitoring and Analytics

### Metrics Collection
- **Sync Success Rates**: Track successful vs failed sync operations
- **Context Size Trends**: Monitor growth in context size over time
- **Conflict Frequency**: Track conflict occurrence and resolution
- **Performance Metrics**: Sync duration and bandwidth usage

### Health Monitoring
- **Service Availability**: Monitor sync service uptime
- **Data Integrity**: Verify data consistency across machines
- **Error Rates**: Track and alert on error conditions
- **User Experience**: Monitor sync latency and user satisfaction

## Troubleshooting

### Common Issues
- **Sync Failures**: Check network connectivity and authentication
- **Conflicts**: Review conflict resolution logs and strategies
- **Missing Context**: Verify schema compliance and data integrity
- **Performance**: Optimize context size and sync frequency

### Diagnostic Tools
- **Sync Status**: Check current synchronization state
- **Context Validation**: Verify context document validity
- **Network Testing**: Test connectivity to sync endpoints
- **Log Analysis**: Review sync operation logs for issues

## Future Enhancements

### Planned Features
- **Intelligent Suggestions**: AI-powered context recommendations
- **Advanced Merging**: Semantic merge strategies for complex conflicts
- **Real-time Collaboration**: Live sharing of context between sessions
- **Analytics Dashboard**: Visual insights into sync patterns and usage

### Integration Opportunities
- **Git Integration**: Sync context with version control workflows
- **Cloud Storage**: Additional storage backend options
- **Mobile Support**: Synchronization with mobile Claude interfaces
- **Team Sharing**: Controlled sharing of context within teams