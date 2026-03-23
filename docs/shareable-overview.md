# Agentic Programming + SDD Notes

> Research notes for building an **agentic programming pipeline** centered on **Spec-Driven Development (SDD)**, with a practical constraint: the target agent platform supports **Skills** and **Subagents**, but **not Agent Teams**.

This document is meant to be a **shareable synthesis** of the research gathered so far, especially around:

- Claude Code / agentic coding workflow
- SDD (Spec-Driven Development)
- How to build a practical SDD engineering loop
- How to adapt that loop to a `skills + subagents` runtime

---

## 1. Why this document exists

The core question behind this repo is:

> How do we design an **agentic software engineering pipeline** that is fast like vibe coding, but reliable enough for real engineering work?

The answer emerging from current industry practice is increasingly clear:

- plain prompt-to-code is useful, but unstable for long-lived systems
- code generation gets dramatically better when intent is made explicit
- **specs, plans, tasks, and validation artifacts** reduce drift
- agentic workflows become more reliable when they are staged, bounded, and reviewable

In short:

**SDD is one of the most promising ways to make AI coding agents usable for serious software engineering.**

---

## 2. Claude Code and the modern agentic coding mental model

Claude Code and similar terminal-native coding agents are best understood not as chatbots that happen to write code, but as **working-session agents**.

### Key shift

Traditional chat use:

```text
question -> answer
```

Agentic coding use:

```text
goal -> plan -> act -> inspect -> revise -> continue
```

### Most important working principles

1. **Steer, don't disappear**
   - Give a concrete target.
   - State constraints and success criteria.
   - Check at milestones.

2. **Context quality matters more than prompt poetry**
   - Relevant files, rules, architecture notes, examples, and screenshots beat vague wishes.

3. **Long tasks should be decomposed**
   - A single overloaded conversation degrades quickly.
   - Isolated workers or subagents preserve focus.

4. **Reusable process beats repeated explanation**
   - If a workflow happens repeatedly, encode it in Skills, templates, checklists, and conventions.

5. **Human role shifts upward**
   - Less line-by-line typing.
   - More intent definition, architecture, review, validation, and governance.

### What Claude Code is especially good at

- repository exploration
- multi-step implementation
- iterative debugging
- following explicit constraints
- operating on real files and commands
- working as an implementation partner under supervision

### What Claude Code still needs from humans

- clear direction
- scope control
- quality gates
- architectural judgment
- review and sign-off

That is exactly why SDD matters.

---

## 3. What is SDD?

**SDD = Spec-Driven Development**.

At a high level:

> The specification becomes the primary source of truth, and implementation is derived from, constrained by, and validated against it.

This is a major inversion of the normal workflow.

### Traditional development (simplified)

```text
idea -> code -> patch problems later
```

### SDD workflow

```text
idea -> spec -> plan -> tasks -> implementation -> validation
```

### The central claim of SDD

- code should not be the first place where intent becomes concrete
- intent should first be expressed in a structured specification
- the spec should shape planning, tasks, implementation, and validation

### Why SDD matters in the AI era

LLMs are very strong at:

- implementation
- transformation
- pattern completion

LLMs are weak at:

- mind reading
- recovering hidden assumptions
- preserving architectural intent unless it is explicit

So when prompts are vague, models fill gaps with guesses.

**SDD reduces guessing by making intent explicit earlier.**

---

## 4. What a good spec should contain

A good spec is not just a PRD and not just prose.

It should usually include:

- problem / user context
- desired behavior
- success criteria
- business rules
- edge cases
- non-goals
- constraints
- integration expectations
- compatibility expectations
- security / performance / operational requirements when relevant

A strong spec is typically:

- clear
- structured
- concise but complete enough
- behavior-oriented
- reviewable
- evolvable
- preferably partially machine-readable where possible

### Practical note

The most effective specs combine:

- **natural language** for intent and scenarios
- **semi-structured artifacts** for contracts and constraints

Examples of structured artifacts:

- OpenAPI / AsyncAPI
- JSON schema
- state transition definitions
- API contracts
- data model docs
- validation checklists

---

## 5. SDD is not one thing: 3 maturity levels

One of the clearest patterns in the recent SDD ecosystem is that “SDD” is being used to describe **different levels of commitment**.

### 1. Spec-First

Write a spec before coding.

- easiest starting point
- already a big improvement over pure vibe coding
- useful for many teams

### 2. Spec-Anchored

The spec is kept and maintained after implementation.

- better for real systems
- supports evolution, maintenance, and review
- much closer to a true engineering loop

### 3. Spec-as-Source

The spec becomes the primary long-term editable artifact, with code treated as generated output.

- ambitious
- powerful in theory
- much harder to operationalize
- not the best starting point for most teams

### Recommended practical starting point

For most real teams, especially when building an internal pipeline:

**Start with `Spec-First + Spec-Anchored`.**

Do **not** begin with full `Spec-as-Source` unless your tooling, governance, and artifact model are already mature.

---

## 6. The practical SDD loop

The most useful working loop found in the research is this:

```text
Intake / Clarify
-> Specify
-> Plan
-> Task Decomposition
-> Implement
-> Validate / Review
-> Feed lessons back into specs, plans, and process
```

### Stage 1: Intake / Clarify

Goal:
- understand what is being asked
- identify ambiguity
- surface constraints early

Outputs:
- short intake note
- questions / assumptions
- clarified objective

### Stage 2: Specify

Goal:
- define the **what** and **why**
- focus on user behavior, outcomes, edge cases, and non-goals

Outputs:
- `spec.md`

### Stage 3: Plan

Goal:
- define the **how**
- select architecture, components, boundaries, contracts, and constraints

Outputs can include:
- `plan.md`
- `research.md`
- `data-model.md`
- `contracts/`
- quickstart or validation notes

### Stage 4: Task Decomposition

Goal:
- break the plan into small, reviewable, isolated units
- enable parallelism where useful

Outputs:
- `tasks.md`

### Stage 5: Implementation

Goal:
- implement task by task under the constraints of the spec and plan

Outputs:
- code changes
- implementation log

### Stage 6: Validation / Review

Goal:
- check not only “does it compile/test”
- but also “does it conform to the spec and constraints”

Outputs:
- validation report
- review notes
- drift findings

### Stage 7: Feedback

Goal:
- improve the upstream process
- if the same kind of mistake happens repeatedly, update the spec, plan, templates, or rules

Outputs:
- retrospective note
- updated templates / Skills / memory

---

## 7. Why agentic pipelines need artifacts, not just agents

One of the most important research conclusions is this:

> The quality of an agentic engineering system depends less on the number of agents and more on the quality of the artifacts they hand to each other.

If everything is just “one more prompt,” then the system is hard to debug, hard to audit, and hard to improve.

If each stage writes a structured artifact, the system becomes tractable.

### A minimal artifact model for a feature

A very practical structure is:

```text
00-intake.md
01-spec.md
02-plan.md
03-research.md
04-data-model.md
05-contracts.md   (or contracts/)
06-tasks.md
07-implementation-log.md
08-validation.md
09-retrospective.md
```

This model creates:

- traceability
- clear handoffs
- inspectable state
- better reviewability
- process memory

---

## 8. Can SDD work without Agent Teams?

Yes.

This is one of the most important conclusions for constrained enterprise runtimes.

If your platform supports only:

- **Skills**
- **Subagents**

then you can still build a very solid SDD pipeline.

### The key mapping

#### Skills
Use Skills for:

- phase instructions
- templates
- checklists
- definitions of done
- output formatting rules
- escalation conditions

In short:

> **Skills define how each stage should be done.**

#### Subagents
Use Subagents for:

- isolated execution
- specialized roles
- expensive analysis
- implementation parallelism
- validation and review

In short:

> **Subagents define who performs each stage.**

This means you do **not** need heavyweight “agent teams” to get the benefits of staged multi-agent engineering.

---

## 9. A strong architecture for `skills + subagents`

The most robust architecture for this environment is:

```text
Main Orchestrator
  ├─ Intake / Clarify Skill
  ├─ Spec Writer Subagent
  ├─ Planner / Architect Subagent
  ├─ Task Decomposer Subagent
  ├─ Implementer Subagent(s)
  ├─ Reviewer / Validator Subagent
  └─ Retrospective / Process Feedback
```

### Suggested role split

#### 1. Intake / Clarifier
- clarifies problem
- collects assumptions and constraints
- creates intake artifact

#### 2. Spec Writer
- writes behavior-oriented feature spec
- includes non-goals and edge cases

#### 3. Planner / Architect
- maps spec to technical approach
- adds architecture, contracts, constraints, validation strategy

#### 4. Task Decomposer
- converts plan into small, executable tasks
- marks dependencies and parallel opportunities

#### 5. Implementer(s)
- implement one task or one task group at a time
- operate within bounded scope

#### 6. Reviewer / Validator
- verifies conformance to spec and plan
- runs tests and checks for drift

#### 7. Retrospective / Process Improver
- identifies process failures
- updates reusable rules and templates

---

## 10. What “engineering closure” actually means

A real SDD system is not complete just because it can generate code.

It becomes a **closed engineering loop** when:

1. every code change traces back to tasks
2. every task traces back to plan/spec
3. validation checks against spec, not just tests
4. repeated failures can improve templates, rules, and upstream artifacts
5. future runs become more reliable because the system learned process constraints

This is the difference between:

- a cool AI coding demo
- and an actual engineering workflow

---

## 11. Recommended rollout strategy

### Level 1: Spec-First Pipeline

Use:
- spec -> plan -> tasks -> implement
- manual review
- low overhead

Best for:
- initial internal adoption
- fast learning
- proving value without overengineering

### Level 2: Spec-Anchored Pipeline

Add:
- persistent feature artifacts
- retrospective stage
- validator role for drift checking
- stronger review gates

Best for:
- long-lived products
- team collaboration
- repeated feature work in existing systems

### Level 3: Semi-Executable Governance

Add:
- stronger machine-readable contracts
- CI checks for drift
- generated tests / docs / schemas
- policy enforcement and governance

Best for:
- mature internal platforms
- compliance-sensitive engineering
- large codebases with many contributors

### Most practical recommendation

Start with **Level 1 + selected Level 2 practices**.

That usually means:

- one orchestrator
- phase-specific Skills
- specialized Subagents
- artifact folders per feature
- human approval checkpoints between major phases
- spec anchoring after implementation

---

## 12. Suggested v1 design principles

If building this system from scratch, a strong v1 should follow these rules:

1. **One orchestrator only**
   - avoid fancy autonomous team graphs initially

2. **Phases are explicit**
   - no jumping straight from request to code

3. **Every phase writes an artifact**
   - make state inspectable

4. **Do not let subagents invent process ad hoc**
   - phase logic should live in Skills and templates

5. **Human checkpoints between major stage transitions**
   - especially before implementation and merge

6. **Validation is dual-track**
   - implementation quality + spec conformance

7. **Retrospectives matter**
   - if the same mistake reappears, update process memory

---

## 13. Why this approach is better than raw vibe coding

Raw vibe coding can be great for:

- experiments
- prototypes
- creative exploration
- low-stakes hacks

But once software becomes:

- long-lived
- collaborative
- integrated into existing systems
- compliance-sensitive
- expensive to rework

then raw vibe coding becomes increasingly fragile.

SDD is best understood as:

> **the disciplined, engineering-grade evolution of vibe coding**

It preserves speed, but adds:

- structure
- traceability
- reviewability
- governance
- repeatability

---

## 14. Source themes that informed this synthesis

This document was synthesized from public material across:

- GitHub Spec Kit docs and blog posts
- Microsoft’s Spec Kit / SDD articles
- InfoQ’s architecture-oriented SDD analysis
- Thoughtworks’ observations on spec quality and workflow design
- Martin Fowler’s comparison of emerging SDD tool styles
- Google Cloud’s agentic coding workflow framing
- Claude Code / AI coding workflow material focused on Skills, Subagents, and structured execution

The strongest common themes across those sources were:

- specs should become active, not passive
- staged artifacts beat one-shot prompting
- agentic coding needs guardrails and review
- context quality determines output quality
- subagent specialization is more useful than monolithic chat sessions
- lightweight, artifact-driven orchestration is more practical than prematurely complex multi-agent systems

---

## 15. Final takeaway

If you want to build a serious internal AI coding workflow, the most practical path is:

> **Build an artifact-driven, spec-anchored SDD pipeline with one orchestrator, phase-specific Skills, and specialized Subagents.**

Not because it is the flashiest design — but because it is the most likely to be:

- debuggable
- extensible
- reviewable
- teachable
- and production-credible

---

## 16. Suggested next steps

After research, the natural next steps are:

1. define v1 system goals and non-goals
2. design the artifact model formally
3. define the stage state machine
4. define each Skill's responsibility
5. define each Subagent role and handoff contract
6. define human approval checkpoints
7. define repository layout and operating conventions
8. only then move into implementation

---

## References

A non-exhaustive reference set used in this synthesis:

- GitHub Spec Kit documentation: <https://github.github.com/spec-kit/>
- GitHub Spec Kit repository: <https://github.com/github/spec-kit>
- GitHub Blog on Spec Kit: <https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/>
- Microsoft DevBlog on Spec Kit / SDD: <https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>
- InfoQ: Spec Driven Development: When Architecture Becomes Executable: <https://www.infoq.com/articles/spec-driven-development/>
- Thoughtworks: Spec-driven development: Unpacking one of 2025’s key new AI-assisted engineering practices: <https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices>
- Martin Fowler: Understanding Spec-Driven-Development: Kiro, spec-kit, and Tessl: <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>
- Google Cloud: What is agentic coding?: <https://cloud.google.com/discover/what-is-agentic-coding>
