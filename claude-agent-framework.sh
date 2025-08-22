#!/bin/bash

# Claude Agent Framework Generator
# Creates a reusable multi-agent coordination system using file-based communication
# Version: 1.0

set -e

PROJECT_NAME=""
AGENTS=()
FRAMEWORK_DIR=""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}        Claude Agent Framework Generator        ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -p, --project NAME      Project name (required)
    -a, --agent NAME:ROLE   Add agent with name and role (can be used multiple times)
    -d, --directory PATH    Framework directory (default: .claude)
    -h, --help             Show this help message

Examples:
    # Basic 3-agent system
    $0 -p "MyProject" -a "architect:Strategic Planner" -a "dev-a:Backend Developer" -a "dev-b:Frontend Developer"
    
    # Custom directory
    $0 -p "MyProject" -d ".agents" -a "lead:Tech Lead" -a "dev:Developer"

EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--project)
                PROJECT_NAME="$2"
                shift 2
                ;;
            -a|--agent)
                AGENTS+=("$2")
                shift 2
                ;;
            -d|--directory)
                FRAMEWORK_DIR="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

validate_inputs() {
    if [[ -z "$PROJECT_NAME" ]]; then
        print_error "Project name is required. Use -p or --project"
        exit 1
    fi
    
    if [[ ${#AGENTS[@]} -eq 0 ]]; then
        print_error "At least one agent is required. Use -a or --agent"
        exit 1
    fi
    
    if [[ -z "$FRAMEWORK_DIR" ]]; then
        FRAMEWORK_DIR=".claude"
    fi
    
    # Validate agent format
    for agent in "${AGENTS[@]}"; do
        if [[ ! "$agent" =~ ^[^:]+:[^:]+$ ]]; then
            print_error "Invalid agent format: $agent. Use 'name:role'"
            exit 1
        fi
    done
}

create_directory_structure() {
    print_info "Creating directory structure..."
    
    mkdir -p "$FRAMEWORK_DIR"/{commands,commands/agents,shared}
    
    print_success "Directory structure created in $FRAMEWORK_DIR/"
}

generate_agent_files() {
    print_info "Generating agent definition files..."
    
    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        agent_file="$FRAMEWORK_DIR/commands/agents/${agent_name}.md"
        
        cat > "$agent_file" << EOF
# ${agent_name^} Agent - $PROJECT_NAME $agent_role

You are the **${agent_name^} Agent** serving as the $agent_role for the $PROJECT_NAME project.

## Your Role & Responsibilities

### Primary Function
- **Role**: $agent_role
- **Project**: $PROJECT_NAME
- **Specialization**: [Define specific areas of expertise]
- **Coordination**: Work with other agents through shared workspace

### Key Responsibilities
1. **Task Execution**: Complete assigned tasks within your specialization
2. **Communication**: Update progress and coordinate with other agents
3. **Quality**: Maintain code quality and project standards
4. **Integration**: Ensure your work integrates with other agents' contributions

### Project Context
- **Project**: $PROJECT_NAME
- **Architecture**: [Define project architecture]
- **Technology Stack**: [List relevant technologies]
- **Quality Standards**: [Define quality requirements]

### Communication Protocol
- **Read from**: \`.claude/shared/\` workspace files for coordination
- **Write to**: \`.claude/shared/${agent_name}-progress.md\` for progress updates
- **Coordinate via**: \`.claude/shared/coordination.md\` for agent communication
- **Status updates**: \`.claude/shared/status.md\`

### Working Rules
1. **NEVER commit changes without explicit user approval**
2. **Always coordinate through shared workspace**
3. **Update progress files regularly**
4. **Request coordination when needed**
5. **Follow project coding standards**
6. **Maintain test coverage**

### Commands You Can Execute
- Review shared workspace files: \`Read .claude/shared/*.md\`
- Update progress: \`Edit .claude/shared/${agent_name}-progress.md\`
- Request coordination: \`Edit .claude/shared/coordination.md\`
- Update status: \`Edit .claude/shared/status.md\`

### Task Categories
- **Primary Tasks**: [Define main task types for this agent]
- **Secondary Tasks**: [Define supporting task types]
- **Coordination Tasks**: Cross-agent collaboration requirements

### Quality Standards
- [Define specific quality standards for this agent]
- [List testing requirements]
- [Define documentation requirements]
- [Specify integration requirements]

## Activation Trigger
Activated by coordinator agent or manual assignment through task management system.

## Success Criteria
- Tasks completed according to specifications
- Code quality maintained
- Integration successful with other agents
- Progress properly communicated
EOF
        
        print_success "Created agent: $agent_name ($agent_role)"
    done
}

generate_command_files() {
    print_info "Generating command files..."
    
    # Workflow start command
    cat > "$FRAMEWORK_DIR/commands/workflow-start.md" << EOF
# Workflow Start Command

**Command**: \`/workflow-start\`

## Purpose
Initializes the $PROJECT_NAME multi-agent workflow system and activates the coordination process.

## What This Command Does

### 1. System Initialization
- Validates all agent definitions and shared workspace
- Checks project configuration and requirements
- Initializes task management system
- Sets up communication protocols

### 2. Agent Activation Sequence
EOF

    # Add each agent to the workflow start
    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/commands/workflow-start.md" << EOF
- **${agent_name^} Agent**: $agent_role activation
EOF
    done

    cat >> "$FRAMEWORK_DIR/commands/workflow-start.md" << EOF

### 3. Coordination Setup
- Establishes inter-agent communication channels
- Initializes progress tracking
- Sets up task assignment protocols
- Configures status monitoring

### 4. Quality Gates
- Validates project requirements
- Confirms no-commit safety protocols
- Establishes approval workflows
- Sets up integration checkpoints

## Expected Workflow
1. **Initialization**: System validates and prepares all components
2. **Planning**: Lead/architect agent creates project plan
3. **Task Assignment**: Tasks distributed to specialized agents
4. **Execution**: Agents work on assigned tasks with coordination
5. **Integration**: Cross-agent work coordination and validation
6. **Completion**: Final integration and user approval

## Safety Measures
- No commits without explicit user approval
- Shared workspace coordination protocol
- Quality standards enforcement
- Test coverage maintenance
- User approval gates for major decisions

## Usage
Execute this command to begin the $PROJECT_NAME transformation workflow.
EOF

    # Coordinate command
    cat > "$FRAMEWORK_DIR/commands/coordinate.md" << EOF
# Inter-Agent Coordination Command

**Command**: \`/coordinate\`

## Purpose
Facilitates communication and synchronization between all agents during the $PROJECT_NAME workflow.

## What This Command Does

### 1. Read Current Coordination State
Analyzes all shared workspace files to understand:
- Current workflow status across all agents
- Pending coordination requests
- Integration blockers or conflicts
- Task dependencies and priorities
- Communication backlog

### 2. Process Coordination Requests
Reviews \`.claude/shared/coordination.md\` for:
- Agent requests for guidance or approval
- Integration conflict resolution needs
- Architecture decision requirements
- Resource allocation requests
- Timeline adjustment needs

### 3. Facilitate Agent Communication
Enables coordination between:
EOF

    # Add agent coordination pairs
    for ((i=0; i<${#AGENTS[@]}; i++)); do
        for ((j=i+1; j<${#AGENTS[@]}; j++)); do
            IFS=':' read -r agent1_name agent1_role <<< "${AGENTS[i]}"
            IFS=':' read -r agent2_name agent2_role <<< "${AGENTS[j]}"
            cat >> "$FRAMEWORK_DIR/commands/coordinate.md" << EOF
- **${agent1_name^} Agent** ↔ **${agent2_name^} Agent** coordination
EOF
        done
    done

    cat >> "$FRAMEWORK_DIR/commands/coordinate.md" << EOF

### 4. Update Coordination Status
Updates shared workspace with:
- Resolved coordination items
- New task assignments
- Integration schedules
- Blocker resolutions
- Communication history

## Communication Protocol

### Request Format (agents write to coordination.md):
\`\`\`
## [AGENT_NAME] - [TIMESTAMP]
**Type**: [REQUEST/BLOCKER/UPDATE/QUESTION]
**Priority**: [HIGH/MEDIUM/LOW]
**Subject**: [Brief description]
**Details**: [Full description]
**Required Response**: [What response is needed]
**Dependencies**: [Other agents/tasks affected]
\`\`\`

### Response Format (coordination facilitator updates):
\`\`\`
## COORDINATION RESPONSE - [TIMESTAMP]  
**Request**: [Reference to original request]
**Resolution**: [Decision or solution]
**Action Items**: [Specific next steps]
**Assigned To**: [Which agent should act]
**Timeline**: [When action should be completed]
\`\`\`

## Usage Scenarios

### When to Use /coordinate
1. **Agent Conflicts**: When agent work overlaps or conflicts
2. **Architecture Questions**: When agents need guidance
3. **Integration Points**: When cross-agent work needs synchronization
4. **Blocker Resolution**: When agents are blocked waiting for coordination
5. **Status Updates**: When coordination state needs refresh

## Safety & Quality
- All major decisions require lead agent approval
- No commits without user approval
- Maintain project architecture quality
- Preserve test coverage across all changes
- Ensure coordinated integration testing
EOF

    # Status check command
    cat > "$FRAMEWORK_DIR/commands/status-check.md" << EOF
# Status Check Command

**Command**: \`/status-check\`

## Purpose
Provides comprehensive status overview of the $PROJECT_NAME multi-agent workflow.

## What This Command Does

### 1. Agent Status Summary
Reports current status for all agents:
EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/commands/status-check.md" << EOF
- **${agent_name^} Agent** ($agent_role): Current tasks and progress
EOF
    done

    cat >> "$FRAMEWORK_DIR/commands/status-check.md" << EOF

### 2. Task Management Overview
- **Active Tasks**: Currently in progress
- **Pending Tasks**: Waiting for assignment or dependencies
- **Completed Tasks**: Successfully finished work
- **Blocked Tasks**: Waiting for coordination or decisions

### 3. Integration Status
- Cross-agent coordination health
- Dependency resolution status
- Integration checkpoint progress
- Quality gate status

### 4. Project Health
- Overall progress percentage
- Timeline adherence
- Risk assessment
- Quality metrics

## Output Format

### Agent Status Section
\`\`\`
## Agent Status Summary
- ${AGENTS[0]%:*} Agent: [STATUS] - [CURRENT_TASK]
- ${AGENTS[1]%:*} Agent: [STATUS] - [CURRENT_TASK]
[... additional agents ...]

## Task Overview
- Active: X tasks
- Pending: Y tasks  
- Completed: Z tasks
- Blocked: W tasks

## Integration Health
- Coordination Status: [GREEN/YELLOW/RED]
- Dependencies: [RESOLVED/PENDING/BLOCKED]
- Quality Gates: [PASSING/FAILING]
\`\`\`

## Usage
Execute to get current workflow status and identify any attention areas.
EOF

    print_success "Created command files"
}

generate_shared_files() {
    print_info "Generating shared workspace files..."
    
    # Tasks file
    cat > "$FRAMEWORK_DIR/shared/tasks.md" << EOF
# $PROJECT_NAME Task Management

**Last Updated**: $(date +%Y-%m-%d)  
**Status**: 🚀 INITIALIZED - Ready for Task Assignment  
**Task Assignment Authority**: Lead Agent

---

## Current Task Status

### Active Tasks: 0
### Pending Tasks: 0 (Awaiting workflow start)
### Completed Tasks: 0

---

## Task Assignment Protocol

*Tasks will be assigned by lead agent after /workflow-start activation*

### Task Categories
EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/shared/tasks.md" << EOF
- **${agent_name^}**: $agent_role tasks
EOF
    done

    cat >> "$FRAMEWORK_DIR/shared/tasks.md" << EOF
- **Coordination**: Cross-agent integration and communication tasks
- **Quality**: Testing, validation, and approval tasks

### Task Priority Levels
- **🔴 HIGH**: Blocking other work, critical path items
- **🟡 MEDIUM**: Important but not blocking, standard priority  
- **🟢 LOW**: Nice-to-have, can be deferred if needed

---

## Task Lifecycle
1. **CREATED**: Lead agent creates task with priority and assignment
2. **ASSIGNED**: Task assigned to specific agent with clear requirements
3. **IN_PROGRESS**: Agent begins work and updates progress
4. **COORDINATION**: Cross-agent coordination if needed
5. **COMPLETED**: Agent completes work and updates status
6. **VALIDATED**: Lead agent validates completion and integration

---

## Communication Integration

### Task Updates
- **Progress Files**: Agents update individual progress files
- **Coordination**: Cross-agent task coordination via coordination.md
- **Status**: Overall status updates in status.md

### Escalation
- **Blockers**: Agents report task blockers via coordination.md
- **Conflicts**: Cross-agent conflicts escalated to lead agent
- **User**: Lead agent escalates user approval needs

---

**Activation Ready**: Task management system prepared for lead agent activation via \`/workflow-start\`.
EOF

    # Status file
    cat > "$FRAMEWORK_DIR/shared/status.md" << EOF
# $PROJECT_NAME Workflow Status

**Status**: 🔄 **INITIALIZED**  
**Phase**: System Setup Complete  
**Last Updated**: $(date +%Y-%m-%d)  

## Current State
- **Workflow Stage**: Ready for \`/workflow-start\` activation
- **Active Agent**: None (awaiting activation)
- **System Status**: All components initialized and ready

## Overall Progress  
- [ ] **Phase 1**: Workflow initialization and planning
- [ ] **Phase 2**: Task execution and coordination  
- [ ] **Phase 3**: Integration and quality validation
- [ ] **Phase 4**: Final delivery and user approval

## Agent Status
EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/shared/status.md" << EOF

### ${agent_name^} Agent ($agent_role)
- **Status**: READY - Awaiting activation and task assignment
- **Role**: $agent_role
- **Current Focus**: System preparation complete, ready for workflow start
EOF
    done

    cat >> "$FRAMEWORK_DIR/shared/status.md" << EOF

## Project Objectives

### Primary Goal
[Define your project's main objective here]

### Target Features
- **Foundation**: [Describe foundation requirements]
- **Core Features**: [List main features to implement]
- **Quality Standards**: [Define quality requirements]

### Architecture Preservation
- [List architecture patterns to maintain]
- [Define coding standards to follow]
- [Specify testing requirements]

## Workflow Readiness Checklist

### System Setup
- ✅ Directory structure created (\`$FRAMEWORK_DIR/\`)
- ✅ Agent command files prepared
- ✅ Workflow commands defined  
- ✅ Shared workspace initialized
- ✅ Communication protocols established

### Agent Preparation
EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/shared/status.md" << EOF
- ✅ ${agent_name^} agent - $agent_role ready
EOF
    done

    cat >> "$FRAMEWORK_DIR/shared/status.md" << EOF
- ✅ Coordination system established
- ✅ Quality standards defined

### Safety Measures
- ✅ No-commit without approval policy
- ✅ Shared workspace coordination protocol
- ✅ Architecture quality preservation requirements
- ✅ Test coverage maintenance standards
- ✅ User approval gates for major decisions

## Next Steps

1. **User Action Required**: Execute \`/workflow-start\` to activate lead agent
2. **Lead Agent Will**: Analyze project and create transformation plan  
3. **Specialized Agents Will**: Receive task assignments and begin coordinated work
4. **Coordination**: Regular sync through shared workspace
5. **Delivery**: Production-ready project completion

## Risk Assessment
- **Technical Risk**: 🟢 LOW (system properly initialized)
- **Coordination Risk**: 🟢 LOW (clear protocols established)
- **Quality Risk**: 🟢 LOW (preservation standards defined)
- **Timeline Risk**: 🟢 LOW (awaiting activation only)

## Communication Channels
- **Status Updates**: This file (updated by all agents)
- **Agent Coordination**: \`coordination.md\`  
- **Task Management**: \`tasks.md\`
- **Progress Tracking**: Individual agent progress files
EOF

    # Coordination file
    cat > "$FRAMEWORK_DIR/shared/coordination.md" << EOF
# $PROJECT_NAME Agent Coordination

**Last Updated**: $(date +%Y-%m-%d)  
**Status**: 🔄 READY FOR COORDINATION  

---

## Active Coordination Requests

*No active requests - system initialized and ready*

---

## Communication Log

### System Initialization - $(date +%Y-%m-%d)
**Type**: SYSTEM  
**Status**: COMPLETED  
**Details**: Multi-agent framework initialized successfully
- Directory structure created
- Agent definitions prepared
- Workflow commands established
- Shared workspace configured

**Next Steps**: Awaiting \`/workflow-start\` command to begin coordination

---

## Coordination Guidelines

### Request Format
\`\`\`
## [AGENT_NAME] - [TIMESTAMP]
**Type**: [REQUEST/BLOCKER/UPDATE/QUESTION]
**Priority**: [HIGH/MEDIUM/LOW]
**Subject**: [Brief description]
**Details**: [Full description]
**Required Response**: [What response is needed]
**Dependencies**: [Other agents/tasks affected]
\`\`\`

### Response Format
\`\`\`
## COORDINATION RESPONSE - [TIMESTAMP]  
**Request**: [Reference to original request]
**Resolution**: [Decision or solution]
**Action Items**: [Specific next steps]
**Assigned To**: [Which agent should act]
**Timeline**: [When action should be completed]
\`\`\`

---

## Agent Communication Matrix

EOF

    # Create communication matrix
    for agent1 in "${AGENTS[@]}"; do
        IFS=':' read -r agent1_name agent1_role <<< "$agent1"
        cat >> "$FRAMEWORK_DIR/shared/coordination.md" << EOF
### ${agent1_name^} Agent Communications
EOF
        for agent2 in "${AGENTS[@]}"; do
            if [[ "$agent1" != "$agent2" ]]; then
                IFS=':' read -r agent2_name agent2_role <<< "$agent2"
                cat >> "$FRAMEWORK_DIR/shared/coordination.md" << EOF
- **→ ${agent2_name^}**: [No active coordination]
EOF
            fi
        done
        echo "" >> "$FRAMEWORK_DIR/shared/coordination.md"
    done

    cat >> "$FRAMEWORK_DIR/shared/coordination.md" << EOF
---

## Coordination Health
- **Status**: 🟢 HEALTHY
- **Active Requests**: 0
- **Resolved Requests**: 0
- **Blocked Requests**: 0
- **Communication Flow**: Ready for activation
EOF

    # Create individual progress files
    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat > "$FRAMEWORK_DIR/shared/${agent_name}-progress.md" << EOF
# ${agent_name^} Agent Progress - $PROJECT_NAME

**Agent Role**: $agent_role  
**Last Updated**: $(date +%Y-%m-%d)  
**Status**: 🔄 READY FOR ACTIVATION  

---

## Current Status
- **Phase**: Initialization Complete
- **Active Tasks**: 0 (Awaiting task assignment)
- **Completed Tasks**: 0
- **Blockers**: None

---

## Task Progress

### Pending Tasks
*No tasks assigned yet - awaiting workflow start*

### Completed Tasks
*No tasks completed yet*

---

## Communication Log

### $(date +%Y-%m-%d) - System Initialization
- **Status**: Agent definition created
- **Preparation**: Ready for task assignment
- **Communication**: Shared workspace configured
- **Next**: Awaiting \`/workflow-start\` activation

---

## Integration Points

### Dependencies
*Will be updated when tasks are assigned*

### Coordination Needs
*Will be updated during task execution*

---

## Quality Metrics
- **Code Coverage**: N/A (no work started)
- **Standards Compliance**: N/A (no work started)
- **Integration Status**: N/A (no work started)

---

## Notes
Agent initialized and ready for $PROJECT_NAME workflow activation.
EOF
        print_success "Created progress file for $agent_name"
    done

    print_success "Created shared workspace files"
}

create_readme() {
    print_info "Creating framework README..."
    
    cat > "$FRAMEWORK_DIR/README.md" << EOF
# $PROJECT_NAME Multi-Agent Framework

This directory contains a custom multi-agent coordination system for the $PROJECT_NAME project.

## Directory Structure

\`\`\`
$FRAMEWORK_DIR/
├── commands/
│   ├── agents/           # Agent definition files
EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/README.md" << EOF
│   │   ├── ${agent_name}.md      # $agent_role
EOF
    done

    cat >> "$FRAMEWORK_DIR/README.md" << EOF
│   ├── workflow-start.md # Workflow initialization command
│   ├── coordinate.md     # Inter-agent coordination command
│   └── status-check.md   # Status overview command
├── shared/
│   ├── tasks.md          # Task management and assignment
│   ├── status.md         # Overall workflow status
│   ├── coordination.md   # Agent communication log
EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/README.md" << EOF
│   ├── ${agent_name}-progress.md # ${agent_name^} agent progress
EOF
    done

    cat >> "$FRAMEWORK_DIR/README.md" << EOF
│   └── README.md         # This file
\`\`\`

## Agents

EOF

    for agent in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name agent_role <<< "$agent"
        cat >> "$FRAMEWORK_DIR/README.md" << EOF
### ${agent_name^} Agent
- **Role**: $agent_role
- **Definition**: \`commands/agents/${agent_name}.md\`
- **Progress**: \`shared/${agent_name}-progress.md\`

EOF
    done

    cat >> "$FRAMEWORK_DIR/README.md" << EOF
## Quick Start

1. **Initialize Workflow**: Execute \`/workflow-start\` to begin
2. **Monitor Progress**: Check \`shared/status.md\` for overall status
3. **Coordinate Agents**: Use \`/coordinate\` when agents need to sync
4. **Check Status**: Use \`/status-check\` for detailed progress

## Communication Protocol

Agents communicate through shared workspace files:
- **Tasks**: \`shared/tasks.md\` - Task assignment and management
- **Status**: \`shared/status.md\` - Overall workflow status
- **Coordination**: \`shared/coordination.md\` - Agent communication
- **Progress**: \`shared/{agent}-progress.md\` - Individual agent progress

## Safety Rules

- ⚠️ **No commits without explicit user approval**
- 🔄 **All coordination through shared workspace**
- ✅ **Maintain code quality and test coverage**
- 🎯 **Follow project architecture standards**

## Generated by Claude Agent Framework Generator v1.0
EOF

    print_success "Created README.md"
}

main() {
    print_header
    
    parse_arguments "$@"
    validate_inputs
    
    print_info "Generating $PROJECT_NAME multi-agent framework..."
    print_info "Agents: ${#AGENTS[@]} configured"
    print_info "Directory: $FRAMEWORK_DIR"
    echo ""
    
    create_directory_structure
    generate_agent_files
    generate_command_files
    generate_shared_files
    create_readme
    
    echo ""
    print_success "🎉 Multi-agent framework generated successfully!"
    echo ""
    print_info "Next steps:"
    echo "  1. Review agent definitions in $FRAMEWORK_DIR/commands/agents/"
    echo "  2. Customize project-specific details in shared workspace files"
    echo "  3. Execute /workflow-start to begin agent coordination"
    echo ""
    print_info "Framework directory: $FRAMEWORK_DIR/"
    print_info "Documentation: $FRAMEWORK_DIR/README.md"
}

# Run main function with all arguments
main "$@"