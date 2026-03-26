# OpenCode Workflow v1 提案

本文是面向当前 `opencode/` 目录的第一版 workflow 提案。

它的目标不是直接开始实现，而是先把下面这些问题对齐：

1. OpenCode 版 workflow 的 v1 范围到底是什么？
2. 我们保留哪些阶段、哪些角色、哪些模板？
3. 哪些能力现在就该做，哪些先明确不做？
4. 为什么这样取舍？

这篇提案以我们当前已有研究为基础，强调：

- lightweight v1
- 真实可运行
- 规范中心
- agent 可操作
- implement 受控

而不是“一次把所有 SDD 理想形态都塞进去”。

---

## 1. 提案结论（先看这个）

如果只看一句话，我的提案是：

> **OpenCode workflow v1 应该做成一个 spec-anchored、artifact-driven、rule-aware、agent-operable、implementation-bounded 的轻量工作流。**

展开来说：

- 用 artifacts 驱动阶段推进
- 用 AGENTS / Rules / Skills 提供 agent-facing 约束
- 用 OpenCode 的 Plan / Build / subagent 能力承载角色分工
- 用 implement checkpoint 保证高风险阶段可刹车
- 暂时不追求 spec-as-source、全自动 archive、重型命令体系

这就是 v1 的核心路线。

---

## 2. v1 的设计原则

### 2.1 先做“能稳定跑”的 workflow，不做“理论上最完整”的 workflow

v1 最重要的不是完整，而是：

- 能解释清楚
- 能让 agent 真正执行
- 能被人审阅
- 出问题能定位

所以 v1 必须克制。

---

### 2.2 规范是中枢，不是附件

v1 必须默认：

- artifacts 是 workflow 核心
- 会话只是交互入口
- prompt 只是调度层，不是事实源

换句话说：

- 不是“agent 聊着聊着顺手写点文件”
- 而是“agent 围绕明确 artifacts 工作”

---

### 2.3 OpenCode 是 runtime，不是流程本身

OpenCode 给我们的，是：

- Plan / Build primary agents
- subagents
- agent config
- permissions
- project-level instructions
- terminal/bash 能力

但真正的 workflow，还是要由我们自己定义。

所以 v1 的核心，不是“充分利用 OpenCode 所有功能”，而是：

> **只利用那些对 workflow 最关键的能力。**

---

### 2.4 implement 必须比前面阶段更受控

这是 v1 的一个明确原则：

- `intake/spec/plan/tasks` 以文档工件为主
- `implement` 开始接触真实代码与脚本

所以 implement 不应与前面阶段同等放行。

v1 必须保留：

- risk assessment
- checkpoint
- validation gate

否则前面所有规范层都可能在 implement 阶段被冲烂。

---

## 3. v1 的目标

### 3.1 我们要实现什么

v1 的目标不是覆盖所有 SDD 理论，而是建立一个**最小可运行且有工程边界**的 workflow。

具体目标：

- 可以围绕 feature 目录组织工作
- 可以沉淀 intake/spec/plan/tasks/implementation/validation 产物
- 可以让 OpenCode 中的不同 agent 角色承担不同阶段工作
- 可以在 implement 前触发 checkpoint
- 可以让 validation 成为真实 gate，而不是形式主义

---

### 3.2 我们暂时不追求什么

v1 明确不追求：

- spec-as-source
- 全自动代码生成流水线
- 完整 constitution 治理框架
- 重型 slash command 体系
- 大而全的 archive / delta 编排系统
- “所有任务都必须走完整重流程”

这些都不是说永远不做，而是：

> **v1 不应该为未来可能有用的复杂性预支维护成本。**

---

## 4. v1 建议保留的阶段

我建议 v1 保留这 6 个阶段：

1. `intake`
2. `spec`
3. `plan`
4. `tasks`
5. `implement`
6. `validate`

可选补充：
- `retrospective`

---

### 4.1 intake

目的：
- 把原始需求压成可进入 spec 的问题定义

产物：
- `00-intake.md`

---

### 4.2 spec

目的：
- 定义 what / why
- 明确行为和验收标准

产物：
- `01-spec.md`

---

### 4.3 plan

目的：
- 定义 how
- 明确实现边界、涉及模块、风险和顺序

产物：
- `02-plan.md`

---

### 4.4 tasks

目的：
- 把 plan 拆成 agent 真能执行的小任务

产物：
- `06-tasks.md`

注：当前编号延续现有仓库风格，保留 `03~05` 的未来预留空间，不在 v1 中强制重编号。

---

### 4.5 implement

目的：
- 基于 spec + plan + tasks 做真实改动

产物：
- `07-implementation-log.md`

v1 要求：
- implement 必须有边界
- implement 必须可中止
- implement 不得默认无条件自动放行

---

### 4.6 validate

目的：
- 验证实现是否符合 spec / plan / tasks
- 判断是否允许继续推进

产物：
- `08-validation.md`

---

## 5. v1 的四层结构

我建议把 OpenCode workflow v1 分成四层。

### 5.1 Artifact Layer

这是 workflow 的事实层。

建议包含：
- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`

职责：
- 保存 feature 当前状态
- 成为 agent 的共享上下文
- 成为 validation / review 的依据

---

### 5.2 Instruction Layer

这是 project-level 规则层。

建议包含：
- `AGENTS.md`
- workflow rules
- stage guidance
- validation / checkpoint rules

职责：
- 定义 agent 如何工作
- 定义边界而不是细节实现
- 减少“同一个项目不同 session 风格漂移”

---

### 5.3 Agent Layer

这是 OpenCode 中的角色层。

建议映射为：

#### Primary agents
- `Plan`：负责 intake/spec/plan/tasks 阶段
- `Build`：负责 implement/validate 阶段

#### Subagents
- `Explore`：只读探索代码与上下文
- `Planner`：整理计划 / 任务
- `Implementer`：执行受限实施
- `Validator`：做验证与差异检查

职责：
- 用不同权限和认知模式承载不同阶段
- 避免一个万能 agent 从头冲到尾

---

### 5.4 Execution Layer

这是 workflow 运行层。

建议包含：
- feature 初始化方式
- 阶段进入条件
- artifact 生成顺序
- implement 风险评估
- checkpoint 触发条件
- validation gate

职责：
- 让 workflow 可执行，而不是只停留在文档结构

---

## 6. v1 建议保留的最小模板集合

建议保留：

- intake template
- spec template
- plan template
- tasks template
- implementation-log template
- validation template

不建议 v1 一开始就额外引入：

- research
- quickstart
- contracts/
- data-model
- archive-delta templates
- constitution 专门模板

这些当然有价值，但更适合 v2/v3 视实际需要再长出来。

---

## 7. v1 建议保留的关键规则

### 7.1 artifact-first
任何阶段讨论，最终都应落到 feature 产物，而不是只留在会话里。

### 7.2 stage-order
默认顺序：

```text
intake -> spec -> plan -> tasks -> implement -> validate
```

### 7.3 stage-gate
不能跳过关键前置：
- 没有 spec 不进 plan
- 没有 plan 不进 tasks
- 没有 tasks 不进 implement
- validate fail 不可视为完成

### 7.4 implement-checkpoint
进入 implement 前进行风险评估：
- `low`：可继续
- `medium/high`：checkpoint / stop

### 7.5 validation-gate
validate 必须回答：
- 做了什么检查
- 与 spec 是否一致
- 是否存在偏移
- 是否允许通过

---

## 8. v1 中 AGENTS / Rules / Skills / Artifacts 的分工

这是 v1 里最需要避免混乱的地方。

### 8.1 AGENTS.md
作用：
- 定义项目级 contract
- 告诉 agent 如何在此项目中工作

应包含：
- 项目目标
- 角色边界
- 可执行命令
- 目录约定
- ask-first / never-do 规则

不应变成：
- 一份超长 prompt 杂糅体

---

### 8.2 Rules
作用：
- 定义行为准则
- 代码风格 / 提交规则 / 结构约束 / 验证要求

应偏规范，不应和 AGENTS.md 重复所有内容。

---

### 8.3 Skills
作用：
- 封装可复用任务能力
- 例如 intake writer、planner、task decomposer、validator

Skill 更像“能力入口”，不是全项目治理文件。

---

### 8.4 Artifacts
作用：
- 保存当前 feature 的事实状态
- 成为 agent 的共享工作面

Artifacts 是 feature-scoped；
AGENTS/Rules/Skills 是 project-scoped。

这个边界在 v1 必须非常清楚。

---

## 9. implement checkpoint 在 v1 中的定位

我建议明确写进提案：

> **implement checkpoint 是 v1 的核心功能，不是未来增强项。**

原因：

- 它直接决定 workflow 会不会重新退化成 vibe coding
- 它是规范层和实现层之间的刹车系统
- 它也是 OpenCode 中 Plan / Build 权限分层最值得被利用的地方

所以 v1 不应该把 implement checkpoint 当作“以后再补”。

---

## 10. v1 为什么不直接照搬 SpecKit / OpenSpec

### 不照搬 SpecKit 的原因
- 太重
- 命令体系太完整
- 治理层太强
- 适合成熟平台，不适合当前 lightweight v1

### 不照搬 OpenSpec 的原因
- delta / archive / 规范中枢思路很值钱
- 但完整 change/archive 系统现在对我们来说太早

### 结论
我们应该：
- 吸收其思想
- 不照搬其完整形态

这也是这份提案最核心的取舍逻辑。

---

## 11. v1 建议的最小落地目录

这不是最终实现，只是为了帮助我们讨论边界。

建议最小目录大致是：

```text
opencode/
├── README.md
├── AGENTS.md
├── rules/
│   ├── workflow.md
│   ├── implement-checkpoint.md
│   └── validation.md
├── prompts/
│   ├── intake.md
│   ├── spec.md
│   ├── plan.md
│   ├── tasks.md
│   ├── implement.md
│   └── validate.md
├── skills/
│   ├── intake-writer/
│   ├── planner/
│   ├── implementer/
│   └── validator/
├── templates/
│   ├── 00-intake.md
│   ├── 01-spec.md
│   ├── 02-plan.md
│   ├── 06-tasks.md
│   ├── 07-implementation-log.md
│   └── 08-validation.md
└── examples/
```

注意：

这只是用于讨论 v1 边界的建议，不代表马上就要全部创建。

---

## 12. v1 的成功标准

v1 是否成功，不看“文件多不多”，而看这些问题：

### 12.1 是否能清楚地从需求推进到 tasks
也就是：
- intake/spec/plan/tasks 这条链是否清楚且稳定

### 12.2 implement 是否真正受控
也就是：
- implement 前是否有 checkpoint
- 高风险时是否能停下来

### 12.3 validation 是否真能作为 gate
也就是：
- 不是写一篇通过报告就算完
- 而是真能检查 spec 与实现一致性

### 12.4 agent 分工是否清楚
也就是：
- Plan / Build / subagent 是否各自边界清晰

### 12.5 项目说明是否足够让新 agent 进入上下文
也就是：
- 不是靠口头解释才能上手

如果这五件事做到，v1 就是成功的。

---

## 13. 我建议的下一步

如果这份提案方向你认可，我建议后续按下面顺序推进：

### 第一步：确认这份提案本身
先确认：
- 保留哪些阶段
- 保留哪些模板
- AGENTS / Rules / Skills / Artifacts 如何分工
- implement checkpoint 是否作为 v1 核心

### 第二步：只搭 project-level 骨架
先不急着写执行脚本，先搭：
- `AGENTS.md`
- `rules/`
- `prompts/`
- `templates/`
- `skills/`

### 第三步：选一个最小 demo 验证 v1
例如只验证：
- intake -> tasks
- implement checkpoint
- validation gate

而不是一开始追求全自动大闭环。

---

## 14. 依据与判断边界

这篇提案不是来自某一篇外部文章的原文翻译，而是基于以下三类输入整理出来的：

### 第一类：OpenCode runtime 能力边界
- Plan / Build
- subagents
- permissions
- project-level config

### 第二类：SDD 外部实践
- SpecKit
- OpenSpec
- Jimmy Song SDD 系列
- Intent-Driven / Fowler / Thoughtworks

### 第三类：我们当前仓库的经验判断
- lightweight shell-based pipeline 已验证的部分
- implement checkpoint 的现实价值
- 文档/模板/脚本过重的风险

所以这份提案应该被理解成：

> **面向我们自己的 OpenCode workflow v1 的设计提案，而不是外部标准答案。**

---

## 15. 参考来源

### OpenCode
- <https://opencode.ai/docs/>
- <https://opencode.ai/docs/agents/>
- <https://github.com/opencode-ai/opencode>

### SDD / 方法论 / 实践
- <https://jimmysong.io/zh/book/ai-handbook/sdd/rules/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/agents/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/skills/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/speckit/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/openspec/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/methodology/>
- <https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>
- <https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/>
- <https://github.com/github/spec-kit>
- <https://github.com/Fission-AI/OpenSpec>
- <https://intent-driven.dev/knowledge/best-practices/>
- <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>
- <https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices>
- <https://agentskills.io/home>
