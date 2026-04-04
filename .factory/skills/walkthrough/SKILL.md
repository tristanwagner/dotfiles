---
name: walkthrough
description: Explore and visualize codebase architecture with interactive diagrams. Use when asked to "walk me through", "show how X works", "explain the flow", "diagram the architecture", or understand how components connect and interact.
---

# Walkthrough

## Overview

Explore codebase architecture by following references, imports, and call sites to build understanding of how components relate. Produces interactive Mermaid diagrams with clickable nodes containing deep-dive documentation.

## When to Use

- Exploring codebase architecture and structure
- Understanding code flows and execution paths
- Visualizing relationships between components, modules, or services
- Onboarding to unfamiliar codebases
- Documenting complex system interactions
- When asked "walk me through", "show how X works", "explain the flow"

## When NOT to Use

- Simple file reading (use Read directly)
- Single file analysis without relationship context
- Modifying or editing code
- Quick lookups of specific symbols or functions
- Reviewing diffs or changes (use code-tour instead)

## Protocol

### 1. Identify the exploration topic

Clarify what the user wants to understand:
- A specific feature or flow (e.g., "How does authentication work?")
- A subsystem or module (e.g., "The event system")
- A data flow (e.g., "From API request to database")
- Overall architecture (e.g., "How is the codebase structured?")

### 2. Explore the codebase

Starting from the entry point, iteratively build understanding:

1. **Find entry points** — Locate the main files, route handlers, or module exports relevant to the topic
2. **Follow imports** — Trace `import` statements to discover connected modules
3. **Follow call sites** — Use grep/finder to find where functions are called from
4. **Map data flow** — Track how data transforms as it flows through the system
5. **Identify boundaries** — Note where modules interface with external systems (DB, APIs, filesystem)

Use these tools for exploration:
- `Read` — Read file contents
- `Grep` — Find specific patterns and references
- `glob` — Discover files by naming patterns
- `finder` — Semantic codebase search

### 3. Build the component map

For each discovered component, document:

| Field | Content |
|-------|---------|
| **ID** | Short identifier for the diagram node |
| **Title** | Human-readable component name |
| **Description** | What this component does, key implementation details |
| **Links** | Source file paths with line ranges |
| **Code snippet** | Optional key code excerpt |

### 4. Map relationships

Identify and classify connections between components:
- **Data flow** — Component A sends data to Component B
- **Dependency** — Component A imports/uses Component B
- **Event** — Component A emits events consumed by Component B
- **Inheritance** — Component A extends Component B

### 5. Generate the diagram

Create a Mermaid diagram (flowchart, sequence, or class diagram as appropriate):

```
flowchart TD
  A[Auth Service] --> B[API Gateway]
  B --> C[Database]
  B --> D[Cache]
```

Rules:
- Use plain text labels — no HTML tags in nodes
- No custom colors, classDefs, or styles — let the UI handle theming
- Choose diagram type based on what best represents the relationships:
  - `flowchart` for architecture and data flow
  - `sequenceDiagram` for request/response flows
  - `classDiagram` for type hierarchies

### 6. Attach deep-dive content to nodes

Each node in the diagram should have metadata:

```json
{
  "A": {
    "title": "Authentication Service",
    "description": "Handles user authentication via JWT tokens. Validates credentials against the user store and issues signed tokens with configurable expiry.",
    "links": [
      {"label": "src/auth/service.ts", "url": "file:///path/to/auth/service.ts"}
    ],
    "codeSnippet": "export const authenticate = async (credentials: Credentials): Promise<Token> => { ... }"
  }
}
```

### 7. Present the walkthrough

Deliver the diagram with a one-sentence summary describing what it illustrates. The interactive diagram allows users to click nodes to see detailed documentation.

## Quality Gates

- [ ] All major components in the flow identified
- [ ] Relationships between components mapped with direction
- [ ] Each node has a meaningful description (not just a label)
- [ ] Source file links included for each component
- [ ] Diagram type matches the nature of the relationships
- [ ] Entry points and boundaries clearly marked

## Exit Protocol

```
---HANDOFF---
- Topic explored: [description]
- Components mapped: [count]
- Diagram type: [flowchart/sequence/class]
- Key findings: [list architectural insights]
- Areas not covered: [list or "none"]
---
```
