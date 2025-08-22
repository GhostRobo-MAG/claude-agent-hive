# Simple Custom Claude Agent Framework 
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
**Built with ❤️ by Alexandru G. Mihai** 
## 🌐 Socials:
[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?logo=linkedin&logoColor=white)](https://linkedin.com/in/https://www.linkedin.com/in/alexandru-g-mihai/) [![X](https://img.shields.io/badge/X-black.svg?logo=X&logoColor=white)](https://x.com/https://x.com/alexghimself) [![email](https://img.shields.io/badge/Email-D14836?logo=gmail&logoColor=white)](mailto:mihai.gl.alexandru@gmail.com) 

## What Is This?

The **Claude Agent Framework** is a custom multi-agent coordination system that enables multiple AI agents to work together on complex projects through file-based communication. Unlike Claude Code's built-in agents (which are isolated and stateless), this framework creates a persistent, collaborative environment where agents can:

- **Coordinate** with each other through shared workspace files
- **Persist state** across multiple sessions and days/weeks
- **Specialize** in different roles (architect, developer, QA, etc.)
- **Scale** to handle enterprise-level projects

## How It Works

### Architecture Overview

```
Project Root/
├── .claude/                    # Framework directory
│   ├── commands/              # Agent definitions & workflow commands
│   │   ├── agents/           # Individual agent specifications
│   │   │   ├── architect.md  # Strategic planning agent
│   │   │   ├── dev-a.md      # Backend developer agent
│   │   │   └── dev-b.md      # Frontend developer agent
│   │   ├── workflow-start.md # Initialize workflow
│   │   ├── coordinate.md     # Inter-agent coordination
│   │   └── status-check.md   # Status overview
│   └── shared/               # Communication workspace
│       ├── tasks.md          # Task management
│       ├── status.md         # Overall progress
│       ├── coordination.md   # Agent communication log
│       ├── architect-progress.md
│       ├── dev-a-progress.md
│       └── dev-b-progress.md
└── your-project-files/
```

### Communication Flow

1. **User** activates workflow with `/workflow-start`
2. **Lead Agent** (usually architect) creates project plan
3. **Specialized Agents** receive task assignments via `tasks.md`
4. **Agents communicate** through `coordination.md`
5. **Progress tracked** in individual progress files
6. **Integration coordinated** through `/coordinate` command

## Quick Start Tutorial

### Step 1: Generate Framework

```bash
# Make the generator executable
chmod +x claude-agent-framework.sh

# Generate a basic 3-agent system
./claude-agent-framework.sh \
  -p "MyProject" \
  -a "architect:Strategic Planner" \
  -a "backend:Backend Developer" \
  -a "frontend:Frontend Developer"
```

### Step 2: Customize Agent Roles

Edit the generated agent files in `.claude/commands/agents/` to match your project needs:

```markdown
# architect.md
You are the **Architect Agent** serving as the Strategic Planner for MyProject.

## Your Role & Responsibilities
- Create comprehensive project plans
- Coordinate backend and frontend agents
- Make architectural decisions
- Gate user approvals for major changes

## Project Context
- **Technology Stack**: React, Node.js, PostgreSQL
- **Architecture**: Microservices with REST APIs
- **Quality Standards**: 90% test coverage, TypeScript everywhere
```

### Step 3: Initialize Workflow

In Claude Code, execute:
```
/workflow-start
```

This will:
- Validate the framework setup
- Activate the architect agent
- Begin project planning and task delegation

### Step 4: Monitor and Coordinate

Use these commands throughout the project:

```
/status-check    # Get overall progress overview
/coordinate      # Facilitate inter-agent communication
```

## Framework Components Explained

### Agent Definitions (`commands/agents/`)

Each agent file defines:
- **Role and responsibilities**
- **Communication protocols**
- **Quality standards**
- **Task categories**
- **Working rules and safety measures**

### Workflow Commands (`commands/`)

- **`workflow-start.md`**: Initializes the entire multi-agent system
- **`coordinate.md`**: Handles agent-to-agent communication
- **`status-check.md`**: Provides comprehensive progress reports

### Shared Workspace (`shared/`)

- **`tasks.md`**: Central task management and assignment
- **`status.md`**: Overall project status and progress
- **`coordination.md`**: Agent communication log and requests
- **`{agent}-progress.md`**: Individual agent progress tracking

## Advanced Usage Examples

### Custom Agent Framework

```bash
# 5-agent DevOps-focused system
./claude-agent-framework.sh \
  -p "CloudMigration" \
  -a "architect:Cloud Architect" \
  -a "backend:API Developer" \
  -a "frontend:React Developer" \
  -a "devops:Infrastructure Engineer" \
  -a "qa:Quality Assurance Engineer"
```

### Specialized Project Types

#### Data Science Project
```bash
./claude-agent-framework.sh \
  -p "MLPipeline" \
  -a "data-scientist:ML Engineer" \
  -a "data-engineer:Pipeline Developer" \
  -a "mlops:ML Operations Specialist"
```

#### Enterprise Integration
```bash
./claude-agent-framework.sh \
  -p "SystemIntegration" \
  -a "architect:Enterprise Architect" \
  -a "backend:Integration Developer" \
  -a "security:Security Engineer" \
  -a "qa:Integration Tester"
```

### Custom Framework Directory

```bash
# Use custom directory (useful for multiple agent systems)
./claude-agent-framework.sh \
  -p "MyProject" \
  -d ".agents-v2" \
  -a "lead:Tech Lead" \
  -a "dev:Full Stack Developer"
```

## Communication Protocols

### Agent Request Format

When agents need coordination, they write to `coordination.md`:

```markdown
## BACKEND-AGENT - 2025-08-22 14:30
**Type**: REQUEST
**Priority**: HIGH
**Subject**: Database schema change needed for user profiles
**Details**: Need to add social_login fields to users table. This affects frontend user components.
**Required Response**: Frontend agent confirmation on UI impact
**Dependencies**: Frontend user profile components
```

### Coordination Response Format

The coordination system responds with:

```markdown
## COORDINATION RESPONSE - 2025-08-22 14:45
**Request**: Backend database schema change
**Resolution**: Schema change approved with UI updates required
**Action Items**: 
  - Backend: Implement migration with rollback plan
  - Frontend: Update user profile components for new fields
**Assigned To**: Both backend and frontend agents
**Timeline**: Complete by end of sprint
```

## Best Practices

### 1. Agent Specialization

**Do:**
- Give each agent clear, non-overlapping responsibilities
- Define specific expertise areas
- Create focused task categories

**Don't:**
- Create agents with overlapping roles
- Make agents too generalized
- Assign tasks outside agent expertise

### 2. Communication Management

**Do:**
- Use formal communication protocols
- Update progress files regularly
- Coordinate major changes through `/coordinate`

**Don't:**
- Skip coordination for cross-agent dependencies
- Update shared files without following protocols
- Make architectural decisions without lead agent approval

### 3. Quality Assurance

**Do:**
- Maintain "no commit without approval" policy
- Preserve test coverage and code quality
- Follow project architecture standards

**Don't:**
- Allow agents to commit changes directly
- Skip integration testing
- Ignore quality gates

### 4. Task Management

**Do:**
- Break complex work into manageable tasks
- Set clear priorities and dependencies
- Track progress through dedicated files

**Don't:**
- Create overly complex task hierarchies
- Ignore task dependencies
- Skip progress updates

## Troubleshooting Common Issues

### Agent Communication Problems

**Problem**: Agents not coordinating effectively
**Solution**: 
- Check `coordination.md` for pending requests
- Use `/coordinate` to facilitate communication
- Review agent task assignments for conflicts

### Progress Tracking Issues

**Problem**: Unclear project status
**Solution**:
- Execute `/status-check` for comprehensive overview
- Review individual agent progress files
- Check `tasks.md` for task completion status

### Integration Conflicts

**Problem**: Agent work not integrating properly
**Solution**:
- Use `/coordinate` to resolve conflicts
- Review shared workspace for communication gaps
- Escalate to lead agent for architectural decisions

## Comparison with Other Approaches

### vs. Claude Code Built-in Agents

| Feature | Custom Framework | Claude Code Agents |
|---------|------------------|-------------------|
| **Persistence** | ✅ Multi-session state | ❌ Stateless |
| **Communication** | ✅ Inter-agent coordination | ❌ No communication |
| **Customization** | ✅ Unlimited agent types | ❌ 3 predefined types |
| **Complexity** | ⚠️ Setup overhead | ✅ Zero setup |
| **Project Scale** | ✅ Enterprise-level | ❌ Simple tasks only |

### vs. Traditional Task Management

| Feature | Custom Framework | Traditional PM |
|---------|------------------|----------------|
| **AI Integration** | ✅ AI agents execute work | ❌ Human execution only |
| **Automation** | ✅ Automated coordination | ❌ Manual coordination |
| **Code Awareness** | ✅ Understands codebase | ❌ External to development |
| **Specialization** | ✅ AI expertise roles | ⚠️ Human expertise required |

## Migration Guide

### From Claude Code Agents

If you've been using Claude Code's built-in agents:

1. **Identify your agent roles** - Map your workflow to specialized agents
2. **Generate framework** - Use the generator with your identified roles
3. **Migrate workflows** - Convert your process to the file-based system
4. **Test coordination** - Ensure agents communicate effectively

### From Manual Workflows

If you've been managing complex projects manually:

1. **Define agent roles** - Identify areas of specialization in your workflow
2. **Set up framework** - Generate the agent system
3. **Train agents** - Customize agent definitions for your project needs
4. **Gradual adoption** - Start with simple tasks and expand

## Real-World Examples

### Example 1: SaaS Application Development

**Project**: Building a multi-tenant SaaS platform

```bash
./claude-agent-framework.sh \
  -p "SaaSPlatform" \
  -a "architect:System Architect" \
  -a "backend:API Developer" \
  -a "frontend:React Developer" \
  -a "security:Security Engineer" \
  -a "devops:Platform Engineer"
```

**Workflow:**
1. Architect designs multi-tenant architecture
2. Backend implements tenant isolation and APIs
3. Frontend builds tenant management UI
4. Security implements authentication and authorization
5. DevOps sets up deployment and monitoring

### Example 2: Legacy System Modernization

**Project**: Migrating monolith to microservices

```bash
./claude-agent-framework.sh \
  -p "ModernizationProject" \
  -a "architect:Migration Architect" \
  -a "analysis:Legacy Analyst" \
  -a "backend:Microservices Developer" \
  -a "integration:Integration Specialist" \
  -a "qa:Migration Tester"
```

**Workflow:**
1. Architect plans migration strategy
2. Analyst maps legacy system dependencies
3. Backend extracts services and implements APIs
4. Integration builds service communication
5. QA validates functionality preservation

### Example 3: Machine Learning Pipeline

**Project**: Building ML training and inference pipeline

```bash
./claude-agent-framework.sh \
  -p "MLPipeline" \
  -a "scientist:Data Scientist" \
  -a "engineer:ML Engineer" \
  -a "platform:MLOps Engineer" \
  -a "data:Data Engineer"
```

**Workflow:**
1. Data Scientist designs models and experiments
2. ML Engineer implements training pipelines
3. MLOps Engineer sets up deployment automation
4. Data Engineer builds data ingestion and processing

## Framework Customization

### Adding New Agent Types

Edit `.claude/commands/agents/new-agent.md`:

```markdown
# Custom Agent - Specialized Role

## Your Role & Responsibilities
- Define specific responsibilities
- List key capabilities
- Specify integration points

## Communication Protocol
- Read from: `.claude/shared/` workspace files
- Write to: `.claude/shared/custom-agent-progress.md`
- Coordinate via: `.claude/shared/coordination.md`

## Quality Standards
- Define agent-specific quality requirements
- List testing responsibilities
- Specify documentation needs
```

### Extending Communication Protocols

Add custom communication patterns to `coordination.md`:

```markdown
### Custom Request Types
- **ARCHITECTURE_REVIEW**: Request architectural decision review
- **SECURITY_AUDIT**: Request security review of changes
- **PERFORMANCE_CHECK**: Request performance impact assessment
```

### Creating Specialized Workflows

Extend `workflow-start.md` for project-specific initialization:

```markdown
### Custom Initialization Steps
1. **Environment Validation**: Check project-specific requirements
2. **Dependency Analysis**: Validate tech stack compatibility
3. **Security Setup**: Initialize security scanning and standards
4. **Performance Baseline**: Establish performance metrics
```

## Conclusion

The Claude Agent Framework transforms how complex software projects are managed by:

1. **Enabling true AI collaboration** through persistent, specialized agents
2. **Scaling to enterprise complexity** with file-based state management
3. **Maintaining quality standards** through coordination protocols
4. **Providing full customization** for any project type or workflow

Whether you're building a simple application or orchestrating a complex system transformation, this framework provides the foundation for AI-powered project management that goes far beyond what's possible with traditional tools or built-in agent systems.

The upfront setup investment pays dividends through:
- **Faster development cycles** with specialized AI expertise
- **Better coordination** through structured communication
- **Higher quality outcomes** through built-in review processes
- **Scalable workflows** that grow with project complexity

Start with the basic 3-agent template, customize it for your needs, and experience the power of coordinated AI agents working together on your most challenging projects.
