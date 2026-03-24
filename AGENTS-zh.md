# AGENTS-zh.md

本文件为在此代码仓库中运行的智能编码代理提供指导。

## 项目概述

**agentic-sdd-pipeline** 是一个基于规范驱动开发（Spec-Driven Development, SDD）的 Shell 脚本编排系统。它以 Markdown 制品作为工作单元，以 Claude Code CLI 作为后端消费者。代码库主要由 Shell 脚本、Markdown 模板和提示词定义组成。

---

## 构建 / 检查 / 测试命令

本项目是基于 Shell 脚本的流水线，没有传统的构建系统。

### 核心命令

```bash
# 初始化新功能
./scripts/init-feature.sh <id> <slug> [title]

# 运行单个阶段
./scripts/run-stage.sh <feature-dir> <stage>

# 执行阶段（run-stage 的便捷封装）
./scripts/execute-stage.sh <feature-dir> <stage>

# 运行自动化工作流
./scripts/auto-workflow.sh <feature-dir> full [start] [end]
./scripts/auto-workflow.sh <feature-dir> single <stage>
./scripts/auto-workflow.sh <feature-dir> range <start> <end>

# 使用 Claude Code 作为后端消费者
./scripts/consume-stage-with-claude.sh <feature-dir> <stage>

# 标记制品完成（更新 state.json）
./scripts/complete-artifact.sh <feature-dir> <artifact-path>

# 查看功能状态
./scripts/feature-summary.sh <feature-dir> <feature-dir>
```

### 有效阶段

`intake`（需求采集）、`spec`（规范）、`plan`（计划）、`tasks`（任务）、`implement`（实施）、`validate`（验证）

### 示例工作流

```bash
# 创建并运行完整流水线
./scripts/init-feature.sh 010 test-feature "测试功能"
./scripts/auto-workflow.sh ./features/010-test-feature full intake tasks

# 运行单个阶段
./scripts/consume-stage-with-claude.sh ./features/010-test-feature spec
./scripts/complete-artifact.sh ./features/010-test-feature 01-spec.md
```

### Shell 脚本检查

未配置正式的检查工具。对于 Shell 脚本：

- 如可用，使用 `shellcheck`：`shellcheck scripts/*.sh`
- 确保 POSIX 兼容性（使用 `#!/usr/bin/env sh`，而非 `#!/bin/bash`）

---

## 代码风格指南

### 基本原则

- **制品优先于代码**：这是一个 Markdown 驱动的流水线。专注于产出高质量的制品（`00-intake.md`、`01-spec.md` 等），而非传统代码。
- **显式优于隐式**：所有约束、假设和非目标必须记录在制品中。
- **阶段纪律**：绝不要跳过阶段。每个制品都建立在前一个制品的基础上。

### Shell 脚本约定

1. **Shebang**：使用 `#!/usr/bin/env sh` 以确保可移植性
2. **变量**：使用小写加下划线（`feature_id`、`current_stage`）
3. **函数**：使用小写加下划线（`state_get`、`json_escape`）
4. **常量**：使用大写（`CURRENT_STAGE`、`STATUS`）
5. **引号**：始终对包含路径或用户输入的变量加引号
6. **错误处理**：对关键脚本使用 `set -e`；读取前检查文件是否存在
7. **退出码**：成功返回 0，失败返回非零值

### Markdown 制品约定

1. **结构**：遵循 `templates/` 目录中的模板
2. **命名**：使用确切名称：`00-intake.md`、`01-spec.md`、`02-plan.md`、`06-tasks.md`、`07-implementation-log.md`、`08-validation.md`
3. **标题**：使用 ATX 风格（`#`、`##`、`###`）
4. **列表**：无序使用 `-`，有序使用 `1.`
5. **代码块**：使用带语言标识的围栏代码块
6. **强调**：关键项使用 `**加粗**`，强调使用 `_斜体_`

### 命名约定

| 项目 | 约定 | 示例 |
|------|------|------|
| 功能文件夹 | `<id>-<slug>` | `006-auto-workflow` |
| 阶段制品 | `<两位数字>-<stage>.md` | `01-spec.md` |
| 状态 JSON 键 | snake_case | `current_stage`、`needs_review` |
| Shell 函数 | snake_case | `state_get`、`feature_derive_id` |

### 错误处理

1. **快速失败**：在必须成功的脚本中使用 `set -e`
2. **检查前置条件**：处理前验证文件存在
3. **有意义的错误**：在错误消息中包含上下文
4. **升级歧义**：当需求不明确时，记录歧义而非猜测

### 状态管理

- 所有功能状态追踪在 `features/<id>-<slug>/state.json` 中
- 使用 `scripts/state-lib.sh` 函数进行状态操作
- 切勿手动修改 state.json；使用 `complete-artifact.sh`

---

## 流水线流程

```
需求采集 intake (00-intake.md)
  → 规范 spec (01-spec.md)
    → 计划 plan (02-plan.md)
      → 任务 tasks (06-tasks.md)
        → 实施 implement (07-implementation-log.md)
          → 验证 validate (08-validation.md)
```

### 转换规则

- `spec` 需要 `00-intake.md`
- `plan` 需要 `01-spec.md`
- `tasks` 需要 `01-spec.md` + `02-plan.md`
- `implement` 需要 `01-spec.md` + `02-plan.md` + `06-tasks.md`
- `validate` 需要 `07-implementation-log.md`

### 实施阶段安全

`implement` 阶段设有风险评估关卡。如果风险为 `medium`（中等）或 `high`（高），将创建检查点，工作流暂停以供人工审查。**绝不绕过此检查点。**

---

## 目录结构

```
.
├── scripts/          # 编排 Shell 脚本
├── runtime/handlers/ # 阶段特定处理器
├── hooks/            # 阶段门控钩子
├── skills/           # 阶段特定技能提示词 (sdd-*)
├── subagents/        # 角色特定子代理提示词
├── templates/        # Markdown 制品模板
├── features/         # 包含制品的功能文件夹
└── docs/             # 系统文档
```

---

## 重要文件

- `CLAUDE.md` - Claude Code 特定指导
- `docs/stage-rules.md` - 详细阶段定义
- `docs/system-design.md` - 架构文档
- `docs/implement-safety-policy.md` - 风险评估策略

---

## 风格检查清单

完成任何任务前，请验证：

- [ ] Shell 脚本使用 `#!/usr/bin/env sh` 且兼容 POSIX
- [ ] 所有必要变量已加引号
- [ ] 阶段转换遵循依赖链
- [ ] 制品遵循 `templates/` 中的模板
- [ ] State.json 通过 `complete-artifact.sh` 更新，而非手动修改
- [ ] 实施阶段检查点得到遵守
- [ ] 歧义被升级而非猜测
