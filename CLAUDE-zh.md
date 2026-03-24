# CLAUDE-zh.md

本文件为 Claude Code (claude.ai/code) 在此代码仓库中工作时提供指导。

## 项目概述

**agentic-sdd-pipeline** 是一个研究兼可运行的项目，演示如何围绕**规范驱动开发（Spec-Driven Development, SDD）**构建 AI 原生的软件开发流水线。它使用 Shell 脚本进行编排，以 Markdown 制品作为工作单元，以 Claude Code CLI 作为主要的后端消费者。

核心论点：一个严肃的智能编码系统可以从一个编排器、阶段特定的技能、专门的子代理、强大的制品模型和一小套钩子开始——不需要重量级的代理团队编排。

## 核心命令

```bash
# 初始化新功能
./scripts/init-feature.sh <id> <slug> [title]
# 示例：./scripts/init-feature.sh 007 my-feature "我的功能"

# 运行单个阶段
./scripts/run-stage.sh <feature-dir> <stage>
# 示例：./scripts/run-stage.sh ./features/007-my-feature spec

# 运行自动化工作流（完整流水线或范围）
./scripts/auto-workflow.sh <feature-dir> full [start-stage] [end-stage]
./scripts/auto-workflow.sh <feature-dir> single <stage>
./scripts/auto-workflow.sh <feature-dir> range <start-stage> <end-stage>
# 示例：./scripts/auto-workflow.sh ./features/007-my-feature full intake tasks

# 直接调用 Claude Code 后端执行阶段
./scripts/consume-stage-with-claude.sh <feature-dir> <stage>

# 标记制品完成（更新 state.json）
./scripts/complete-artifact.sh <feature-dir> <artifact-path>

# 查看功能状态
./scripts/feature-summary.sh <feature-dir>
```

有效阶段：`intake`（需求采集）、`spec`（规范）、`plan`（计划）、`tasks`（任务）、`implement`（实施）、`validate`（验证）

## 架构

### 流水线流程

每个功能经历 6 个阶段，每个阶段产出一个 Markdown 制品：

```
需求采集 intake (00-intake.md)
  → 规范 spec (01-spec.md)
    → 计划 plan (02-plan.md)
      → 任务 tasks (06-tasks.md)
        → 实施 implement (07-implementation-log.md)
          → 验证 validate (08-validation.md)
```

状态追踪在 `features/<id>-<slug>/state.json` 中。

### 组件层次

**编排层（`scripts/`）** — Shell 脚本管理阶段顺序、钩子调用和后端分发。`auto-workflow.sh` 是主入口；`run-stage.sh` 处理单个阶段执行；`state-lib.sh` 提供共享状态辅助函数。

**运行时处理器（`runtime/handlers/`）** — 每个阶段一个处理器。每个处理器调用 `build-stage-bundle.sh` 组装 `.runtime/<stage>.bundle.md` 上下文文件，然后报告就绪状态。Bundle 包含技能提示词、子代理角色、模板和输入/输出制品路径。

**钩子（`hooks/`）** — 轻量级阶段门控。`before_stage_transition.sh` 强制执行制品依赖链（例如 spec 需要 `00-intake.md`）。`on_feature_init.sh` 搭建功能文件夹。其他钩子是待实现的骨架。

**提示词层（`skills/`、`subagents/`）** — 技能定义每个阶段的行为规则（`skills/sdd-<stage>/SKILL.md`）。子代理定义角色特定的人设（`subagents/<role>.md`）。这些是提示指令，不是可执行代码。

**模板（`templates/`）** — 每种制品类型的最小 Markdown 支架。

**后端消费者（`scripts/consume-stage-with-claude.sh`）** — 组装完整提示词（技能 + 子代理 + 模板 + 先前制品）并调用 `claude` CLI。这是实际为每个阶段调用 Claude Code 的组件。

### 功能文件夹结构

```
features/<id>-<slug>/
├── state.json               # 当前阶段、状态、时间戳
├── 00-intake.md             # 原始请求 → 结构化需求
├── 01-spec.md               # 行为导向的规范
├── 02-plan.md               # 技术计划
├── 06-tasks.md              # 有界任务列表
├── 07-implementation-log.md # 实施过程中的变更记录
├── 08-validation.md         # 验证结果
└── .runtime/
    └── <stage>.bundle.md    # 为后端组装的上下文
```

### 实施阶段安全

实施阶段设有风险评估关卡（`assess-implement-risk.sh`）。如果风险为 `medium`（中等）或 `high`（高），`implement-checkpoint.sh` 会创建检查点并暂停工作流以供人工审查，然后再继续。这是有意设计——不要绕过它。

## 文档

- `docs/system-design.md` — 完整 v1 架构
- `docs/auto-workflow.md` — 工作流运行器文档
- `docs/implement-safety-policy.md` — 风险评估和检查点策略
- `docs/skills-and-subagents.md` — 提示词层架构
- `docs/runtime-wiring.md` — 处理器分发机制
- `docs/命令使用说明.md` — 中文命令指南
