# Claude User Persistence

A centralized repository for synchronizing Claude sessions, context, tooling, and data sources across multiple machines and environments.

## 🎯 Project Goal

Create a unified persistence layer that enables seamless context sharing and session continuity across all Claude interactions, eliminating the need to recreate context and reconfigure tools for each new session.

## 🏗️ Architecture Overview

### Core Components

```
┌─────────────────────────────────────────────────────────────┐
│                    CONTEXT-SYNC SKILL                      │
│ - Defines interface for retrieving/storing context         │
│ - References to MCP configs, skill manifests, project ctx  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                    n8n Orchestration                       │
│                  @ n8n.casonclark.com                      │
│ - Webhook endpoints for CRUD operations                    │
│ - Orchestrates sync across machines                        │
│ - Context-sync workflow integration                        │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                  Persistence Layer                         │
│ Options:                                                    │
│ • Azure Blob Storage (M365 ecosystem)                      │
│ • Supabase (real-time, generous free tier)                 │
│ • SharePoint List (Graph API native)                       │
└─────────────────────────────────────────────────────────────┘
```

### Decision Matrix

| Approach | Pros | Cons |
|----------|------|------|
| **Custom Skill + Supabase** | Real-time sync, API-first, row-level security, generous free tier | Another vendor outside Microsoft stack |
| **Custom Skill + Azure Blob/Cosmos** | Stays in M365 ecosystem, Graph API integration | More complex setup, cost considerations |
| **Custom Skill + Git Repo** | Version control, PR-based updates, works with worktrees skill | Not real-time, manual sync |
| **Custom MCP Server** | Native Claude integration, tool-level access | Requires hosting, more complex |

## 📋 What Gets Synchronized

### Context Documents
- **Session Context**: Active project information, current tasks, conversation history
- **User Preferences**: Claude behavior customizations, response styles, workflow preferences
- **Tool Configurations**: MCP server settings, skill configurations, API credentials
- **Project Mappings**: Active projects, file paths, dependency information

### Skills & Tools
- **Custom Skills**: Skill manifests, scripts, templates
- **MCP Configurations**: Server endpoints, authentication, tool registrations
- **Workflow Templates**: Common task patterns, automation scripts

### Cross-Machine State
- **Active Sessions**: Current work contexts across different machines
- **Environment Mappings**: Machine-specific paths and configurations
- **Sync Status**: Last sync timestamps, conflict resolution

## 📁 Project Structure

```
Claude-User-Persistence/
├── README.md                    # This file
├── skills/
│   └── context-sync/            # Main synchronization skill
│       ├── SKILL.md            # Skill interface definition
│       ├── scripts/
│       │   ├── pull_context.py # Fetch from central repo
│       │   ├── push_context.py # Push local changes
│       │   └── diff_context.py # Compare local vs remote
│       ├── references/
│       │   ├── schema.md       # Context document structure
│       │   ├── mcp-registry.md # Available MCPs across machines
│       │   └── skill-manifest.md # Skill inventory
│       └── assets/
│           └── templates/      # Boilerplate for new contexts
├── schemas/
│   ├── context-schema.json     # JSON schema for context documents
│   ├── session-schema.json     # Session state schema
│   └── sync-schema.json        # Synchronization metadata
├── n8n-workflows/
│   ├── context-sync-api.json   # n8n workflow for API endpoints
│   └── conflict-resolution.json # Workflow for handling sync conflicts
├── backend/
│   ├── api/                    # API layer for persistence operations
│   ├── models/                 # Data models and validation
│   └── sync/                   # Synchronization logic
├── docs/
│   ├── setup-guide.md          # Initial setup instructions
│   ├── sync-protocol.md        # Synchronization protocol documentation
│   └── troubleshooting.md      # Common issues and solutions
└── config/
    ├── environments/           # Environment-specific configurations
    └── templates/              # Configuration templates
```

## 🚀 Implementation Phases

### Phase 1: Foundation
- [x] Repository setup with comprehensive documentation
- [ ] Basic project structure
- [ ] Data schema definition
- [ ] Context-sync skill interface

### Phase 2: Core Functionality
- [ ] n8n workflow for API operations
- [ ] Persistence layer implementation (starting with Supabase)
- [ ] Basic sync operations (pull/push/diff)
- [ ] Conflict resolution strategy

### Phase 3: Integration
- [ ] MCP server integration for native Claude access
- [ ] Cross-machine synchronization testing
- [ ] Automated context discovery and mapping
- [ ] Real-time sync capabilities

### Phase 4: Advanced Features
- [ ] Intelligent context suggestions
- [ ] Session analytics and optimization
- [ ] Automated skill deployment
- [ ] Multi-environment support

## 🔧 Technology Stack

### Core Technologies
- **Python**: Primary development language for scripts and API
- **n8n**: Workflow orchestration and API layer
- **Supabase**: Initial persistence layer (PostgreSQL + real-time)
- **TypeScript**: MCP server development
- **JSON Schema**: Data validation and structure

### Integration Points
- **Claude MCP**: Native tool integration
- **Microsoft Graph API**: SharePoint/Azure integration (future)
- **Git**: Version control for skill and configuration management
- **Docker**: Containerization for deployment

## 📖 Key Documentation

### Setup & Configuration
- [Setup Guide](docs/setup-guide.md) - Initial installation and configuration
- [Environment Configuration](config/environments/README.md) - Per-machine setup

### Development
- [Sync Protocol](docs/sync-protocol.md) - How synchronization works
- [Schema Documentation](schemas/README.md) - Data structure specifications
- [Skill Development](skills/README.md) - Creating and modifying skills

### Operations
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Monitoring](docs/monitoring.md) - System health and performance

## 🔄 Synchronization Flow

1. **Context Detection**: Automatically detect active Claude sessions and project context
2. **Change Detection**: Identify modifications to skills, configurations, or context
3. **Conflict Resolution**: Handle concurrent changes across multiple machines
4. **Bidirectional Sync**: Ensure all machines have consistent state
5. **Rollback Support**: Ability to revert to previous context states

## 🎛️ Configuration Management

### Per-Machine Configuration
- Local file paths and environment variables
- Machine-specific skill availability
- Network and authentication settings

### Global Configuration
- Shared skill definitions and templates
- Common project mappings
- Synchronization preferences

## 🔐 Security Considerations

- **API Key Management**: Secure storage and rotation of sensitive credentials
- **Access Control**: Machine-based permissions and role definitions
- **Data Encryption**: Encrypted transmission and storage of sensitive context
- **Audit Logging**: Track all synchronization operations and access patterns

## 🚦 Getting Started

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd Claude-User-Persistence
   ```

2. **Setup Environment**
   ```bash
   cp config/templates/local.env.template .env
   # Edit .env with your configuration
   ```

3. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   npm install  # For TypeScript components
   ```

4. **Initialize Context Sync**
   ```bash
   python skills/context-sync/scripts/init_sync.py
   ```

5. **Test Synchronization**
   ```bash
   python skills/context-sync/scripts/pull_context.py --dry-run
   ```

## 📈 Success Metrics

- **Context Restoration Time**: Time to restore full working context on new machine
- **Sync Accuracy**: Percentage of successful synchronizations without conflicts
- **Cross-Session Continuity**: Ability to seamlessly continue work across machines
- **Tool Availability**: Consistent availability of skills and tools across environments

## 🤝 Contributing

This is a personal workspace project, but the patterns and architecture can be adapted for other use cases. Key areas for improvement:

- Enhanced conflict resolution algorithms
- Additional persistence layer options
- Advanced context analysis and optimization
- Integration with other AI development workflows

---

*This repository serves as the single source of truth for Claude session persistence and will be updated as the system evolves.* 
