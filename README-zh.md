# agentic-sdd-pipeline

一个以研究为先的开源项目，关于围绕**规范驱动开发（Spec-Driven Development, SDD）**构建**智能编程流水线**。

本仓库关注许多实际系统存在的一个实际约束：

- 你可能拥有**技能（Skills）**
- 你可能拥有**子代理（Subagents）**
- 你可能拥有**钩子（Hooks）**
- 但你可能**没有**完整的**代理团队（Agent Teams）**

本项目的目标是探索在这种环境下，一个纪律严明、制品驱动的 SDD 工作流能走多远。

---

## 本仓库的定位

本项目研究如何构建一个 AI 编码工作流，使其：

- 比传统人工交接更快
- 比原始的氛围编码更可靠
- 结构化程度足以支撑真正的工程工作
- 可与技能 + 子代理 + 钩子组合
- 适合未来的系统设计和实现

简而言之：

> **使用规范、计划、任务、验证制品、轻量级钩子和显式的提示词层角色，将智能编码转变为工程流水线。**

---

## 当前状态

本仓库已超越纯研究笔记。

当前包含：

- 可共享的背景研究
- v1 系统设计文档
- 轻量级 v1 定义
- 阶段规则
- 最小制品模板
- 钩子骨架
- 运行时接线和处理器分发
- 阶段特定的技能提示词
- 角色特定的子代理提示词
- 用于执行交接的阶段 Bundle 生成
- 真实试点功能和运行时演示
- 使用 Claude Code CLI 的首批真实后端驱动阶段
- 支持完整/单阶段/范围模式的自动化工作流运行器
- 带安全控制的实验性实施阶段接线

这意味着仓库现在包含一个**带有真实提示词层、执行 Bundle、后端消费和早期工作流自动化的轻量级可运行骨架**，而不仅仅是理论。

---

## 为什么这很重要

现代编码代理越来越擅长：

- 探索代码仓库
- 生成代码
- 迭代调试
- 跨多个文件应用补丁
- 运行测试并对失败做出反应

但当出现以下情况时，它们仍然力不从心：

- 需求模糊
- 架构隐含
- 约束分散
- 任务过大
- 没有验证关卡

这正是**规范驱动开发（SDD）**发挥作用的地方。

SDD 将工作流从：

```text
提示词 -> 代码 -> 事后修补问题
```

转变为：

```text
意图 -> 规范 -> 计划 -> 任务 -> 实施 -> 验证
```

---

## 当前论点

本仓库的工作论点是：

> 一个严肃的智能编码系统**不需要**首先依赖重量级的代理团队编排。
> 它可以从**一个编排器**、**阶段特定的技能**、**专门的子代理**、强大的**制品模型**和一小套**钩子**开始。

这意味着一个实用的 v1 可以围绕以下内容构建：

- 一个编排器代理
- 明确的阶段
- 每个阶段的可复用技能
- 用于专门执行的子代理
- 用于阶段门控和脚手架的钩子
- 带有可追溯制品的功能文件夹
- 验证和回顾循环

---

## 仓库结构

```text
.
├── README.md
├── docs/
│   ├── artifact-model.md
│   ├── auto-workflow.md
│   ├── backend-consumers.md
│   ├── checkpoint-policy.md
│   ├── execution-integration.md
│   ├── implement-automation-notes.md
│   ├── implement-safety-policy.md
│   ├── lightweight-v1.md
│   ├── prompt-layer.md
│   ├── rollout-plan.md
│   ├── runtime-artifacts-policy.md
│   ├── runtime-contracts.md
│   ├── runtime-wiring.md
│   ├── shareable-overview.md
│   ├── skill-interfaces.md
│   ├── skills-and-subagents.md
│   ├── stage-rules.md
│   ├── subagent-interfaces.md
│   ├── 命令使用说明.md
│   ├── 项目介绍说明.md
│   └── system-design.md
├── examples/
│   ├── 001-demo-search/
│   └── 002-runtime-demo/
├── hooks/
│   ├── README.md
│   ├── after_artifact_write.sh
│   ├── after_validation.sh
│   ├── before_implement.sh
│   ├── before_stage_transition.sh
│   └── on_feature_init.sh
├── runtime/
│   └── handlers/
├── skills/
│   ├── sdd-implement/
│   ├── sdd-intake/
│   ├── sdd-plan/
│   ├── sdd-spec/
│   ├── sdd-tasks/
│   └── sdd-validate/
├── subagents/
│   ├── implementer.md
│   ├── intake-writer.md
│   ├── planner.md
│   ├── spec-writer.md
│   ├── task-decomposer.md
│   └── validator.md
├── scripts/
│   ├── auto-workflow.sh
│   ├── assess-implement-risk.sh
│   ├── build-stage-bundle.sh
│   ├── complete-artifact.sh
│   ├── consume-stage-with-claude.sh
│   ├── execute-stage.sh
│   ├── feature-summary.sh
│   ├── implement-checkpoint.sh
│   ├── init-feature.sh
│   ├── run-stage.sh
│   └── state-lib.sh
├── templates/
│   ├── 00-intake.md
│   ├── 01-spec.md
│   ├── 02-plan.md
│   ├── 06-tasks.md
│   ├── 07-implementation-log.md
│   └── 08-validation.md
└── features/
```

---

## 可运行的轻量级工作流

当前仓库支持：

- 逐阶段执行
- 阶段范围执行
- 早期完整工作流执行
- 早期以文本为中心阶段的后端消费
- 带安全控制的实验性实施阶段接线

### 当前能力

- 搭建功能文件夹
- 从模板创建基线制品
- 使用钩子进行阶段转换门控
- 通过运行时接线分发阶段处理器
- 维护更丰富的 `state.json` 元数据
- 为执行交接生成阶段 Bundle
- 让真实的 Claude Code 后端消费 `intake`、`spec`、`plan`、`tasks`、`implement` 和 `validate` 阶段
- 在 `full`、`single` 和 `range` 模式下运行自动化工作流
- 对 `implement` 应用风险评估和检查点生成

### 示例命令

```sh
./scripts/feature-summary.sh ./features/002-runtime-demo
./scripts/consume-stage-with-claude.sh ./features/005-claude-spec-consumer spec
./scripts/consume-stage-with-claude.sh ./features/005-claude-spec-consumer plan
./scripts/consume-stage-with-claude.sh ./features/005-claude-spec-consumer tasks
./scripts/consume-stage-with-claude.sh ./features/005-claude-spec-consumer validate
./scripts/auto-workflow.sh ./features/006-auto-workflow full intake tasks
./scripts/auto-workflow.sh ./features/005-claude-spec-consumer single validate
./scripts/auto-workflow.sh ./features/005-claude-spec-consumer range plan tasks
```

---

## 推荐的成熟度模型

本仓库目前将 SDD 视为有三个实用的成熟度级别：

### 1. 规范优先（Spec-First）
- 在编码之前编写规范
- 已经比纯氛围编码好很多
- 良好的起点

### 2. 规范锚定（Spec-Anchored）
- 实施后保持规范的活性
- 用于演进、审查和维护
- 推荐的真实内部流水线目标

### 3. 规范即源码（Spec-as-Source）
- 规范成为主要的长期可编辑制品
- 强大，但对大多数 v1 系统过于激进

**推荐起点：**

- 从**规范优先 + 规范锚定**开始
- 避免直接跳到完整的**规范即源码**

---

## 核心文档

### 中文说明
- [`docs/项目介绍说明.md`](docs/项目介绍说明.md)
- [`docs/命令使用说明.md`](docs/命令使用说明.md)
- [`docs/Claude-Code-中文上手-demo.md`](docs/Claude-Code-中文上手-demo.md)
- [`docs/从0新建Feature的中文Demo.md`](docs/从0新建Feature的中文Demo.md)
- [`docs/implement-checkpoint-进阶中文Demo.md`](docs/implement-checkpoint-进阶中文Demo.md)

### 自动化工作流
- [`docs/auto-workflow.md`](docs/auto-workflow.md)

### 概述和研究
- [`docs/shareable-overview.md`](docs/shareable-overview.md)

### 系统设计
- [`docs/system-design.md`](docs/system-design.md)
- [`docs/artifact-model.md`](docs/artifact-model.md)
- [`docs/skills-and-subagents.md`](docs/skills-and-subagents.md)
- [`docs/stage-rules.md`](docs/stage-rules.md)
- [`docs/lightweight-v1.md`](docs/lightweight-v1.md)
- [`docs/runtime-contracts.md`](docs/runtime-contracts.md)
- [`docs/runtime-wiring.md`](docs/runtime-wiring.md)
- [`docs/execution-integration.md`](docs/execution-integration.md)
- [`docs/backend-consumers.md`](docs/backend-consumers.md)
- [`docs/skill-interfaces.md`](docs/skill-interfaces.md)
- [`docs/subagent-interfaces.md`](docs/subagent-interfaces.md)
- [`docs/prompt-layer.md`](docs/prompt-layer.md)
- [`docs/rollout-plan.md`](docs/rollout-plan.md)

### 安全 / 策略
- [`docs/implement-safety-policy.md`](docs/implement-safety-policy.md)
- [`docs/checkpoint-policy.md`](docs/checkpoint-policy.md)
- [`docs/runtime-artifacts-policy.md`](docs/runtime-artifacts-policy.md)
- [`docs/implement-automation-notes.md`](docs/implement-automation-notes.md)

---

## 适用人群

如果你正在做以下工作，本仓库与你相关：

- 设计内部智能编码平台
- 实验 AI 原生软件工程工作流
- 尝试以实用方式应用 SDD
- 在仅支持技能 + 子代理 + 钩子的受限运行时中工作
- 有兴趣将研究转化为真正的工程流水线

---

## 项目状态

本仓库当前处于**带有运行时接线、提示词层、执行 Bundle、后端驱动的早期阶段循环、工作流链式调用和实验性实施安全控制的轻量级可运行 v1 骨架**阶段。

已完成的工作：

- 收集关于 SDD 和智能编码的公开材料
- 综合可共享的概述
- 编写系统设计文档
- 定义轻量级 v1 模型
- 创建最小模板
- 创建钩子骨架
- 添加运行时接线、处理器分发和更强的状态管理
- 添加阶段特定的技能提示词文件
- 添加角色特定的子代理提示词文件
- 添加阶段 Bundle 生成以连接运行时状态和提示词文件
- 在 `intake`、`spec`、`plan`、`tasks` 和 `validate` 阶段证明了 Claude Code 的真实后端消费
- 添加支持完整/单阶段/范围模式的自动化工作流执行
- 添加实验性的实施阶段接线和安全/检查点策略
- 通过工作流运行了真实试点功能

下一步：

- 更彻底地验证实验性的 `implement` 阶段
- 通过更多依赖阶段 Bundle 减少提示词重复
- 基于更多试点改进模板
- 加强验证行为
- 改进检查点/审批用户体验
- 运行更多样化的试点功能

---

## 参考资料

初始来源主题包括：

- GitHub Spec Kit 文档和博客文章
- Microsoft 关于 Spec Kit / SDD 的文章
- InfoQ 对 SDD 作为架构模式的分析
- Thoughtworks 关于良好规范和工作流设计的观察
- Martin Fowler 对 SDD 工具风格的比较
- Google Cloud 关于智能编码的材料

更完整的参考列表包含在：

- [`docs/shareable-overview.md`](docs/shareable-overview.md)

---

## 许可证

尚未选择许可证。

在添加许可证之前，请将此仓库视为**默认保留所有权利**。
