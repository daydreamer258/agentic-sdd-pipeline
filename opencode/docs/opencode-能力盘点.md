# OpenCode 能力盘点（面向 workflow 设计）

本文目标不是介绍 OpenCode 的全部细节，而是从**搭建可运行 workflow** 的角度，整理它目前值得利用的能力边界。

---

## 1. OpenCode 是什么

根据 OpenCode 官方文档与公开资料，OpenCode 是一个开源 AI coding agent，提供：

- 终端界面
- 桌面应用
- IDE 扩展

对我们当前要做的事情来说，最重要的是：

> **OpenCode 本质上是一个可配置的 coding agent runtime。**

也就是说，它不只是聊天窗口，而是一个可以：

- 读取项目
- 调用工具
- 编辑文件
- 执行 bash
- 切换 agent 模式
- 调用 subagent
- 管理项目级 agent 配置

的工作环境。

---

## 2. 对 workflow 最关键的能力

### 2.1 Plan / Build 双主模式

OpenCode 内置两个最关键的 primary agent：

- **Build**：默认开发模式，拥有完整工具能力
- **Plan**：偏分析/规划模式，默认限制写文件和 bash 改动

这点对 SDD 非常友好，因为一个健康的 SDD workflow 本来就应该把：

- 规划
- 实施

分开。

可以直接对应成：

- `Plan` → intake/spec/plan/tasks 等前置阶段
- `Build` → implement / validate 等执行阶段

这是 OpenCode 相比“只有一个全能 agent”的地方更适合做 workflow 的原因之一。

---

### 2.2 Subagent 机制

OpenCode 支持 subagent，并支持：

- 自动调用
- 手动通过 `@` mention 调用
- 在 session 里切换 child session

官方内置的典型 subagent 包括：

- `general`
- `explore`

这意味着我们可以在 workflow 里天然区分：

- 主 orchestrator
- 读代码 / 搜索型 subagent
- 规划型 subagent
- 实施型 subagent
- 审查 / 验证型 subagent

对 SDD 来说，这是很关键的能力，因为好的 SDD 并不只是“一个 agent 干到底”，而是：

> **让不同阶段使用不同认知模式和不同权限边界。**

---

### 2.3 Agent 可配置：prompt / model / permissions / steps

OpenCode agent 支持配置：

- `description`
- `prompt`
- `model`
- `temperature`
- `steps`
- `permission`

尤其值得注意的是：

#### permissions
可以分别控制：
- `edit`
- `bash`
- `webfetch`

并支持：
- `allow`
- `ask`
- `deny`

甚至支持对特定 bash 命令做精细控制。

这对 workflow 设计非常有价值，因为你可以天然做出：

- 只读探索 agent
- 只做计划不准写文件的 plan agent
- 允许读写但限制 bash 的 implement agent
- 允许 `git diff` 但禁止 `git push` 的 reviewer agent

这类权限分层，正好是健康 workflow 的基础设施。

---

### 2.4 项目级 agents 配置

OpenCode 支持两类 agent 配置方式：

- `opencode.json`
- `.opencode/agents/*.md`

而且支持：

- 全局配置
- 项目级配置

这对我们当前在 `opencode/` 里做一套独立 workflow 特别重要。

因为这意味着我们不一定需要一上来先写复杂代码，很多 workflow 第一版完全可以通过：

- agent markdown
- prompt 文件
- 权限配置
- 目录约定

先搭起来。

这非常适合做 lightweight v1。

---

### 2.5 /init 能生成 AGENTS.md

官方 docs 提到 OpenCode 可以通过 `/init` 分析项目并生成 `AGENTS.md`。

这件事的意义不是“自动帮你写文档”，而是：

> **OpenCode 预期每个项目都应该有 agent-facing project instructions。**

对我们来说，这意味着如果要做一套运行在 OpenCode 上的 workflow，应该提前接受一个现实：

- 项目说明
- agent 约束
- workflow 规则
- 阶段说明

最好是显式写成 agent 可以读取的文件，而不是全靠会话里的口头 prompt。

---

### 2.6 终端友好 + bash 集成

OpenCode 天然跑在 terminal 里，支持 bash 命令执行。

这意味着它很适合接：

- shell 脚本式 workflow
- git 状态检查
- feature 初始化脚本
- 产物目录生成
- 校验命令

而我们当前 `agentic-sdd-pipeline` 本身就是 POSIX shell 风格，这两者是高度兼容的。

这其实是个好消息：

> **不需要为了 OpenCode 推翻现有 shell-based SDD 设计。**

更多是“换 runtime 与交互层”，而不是“换整个方法论”。

---

### 2.7 分享会话 / 上下文压缩

公开资料显示 OpenCode 支持：

- shareable sessions
- auto compaction / context summarization

这意味着它在较长工作流下，天然比“单轮 prompt 复制粘贴”更适合做多阶段任务。

不过也要注意：

- 即使有 compaction，也不代表可以无限堆上下文
- 好的 workflow 仍然应该以 artifacts 为中心，而不是把所有信息塞进一条对话里

这反而进一步说明：

> **OpenCode 适合 artifact-driven workflow，而不是 prompt-bloat workflow。**

---

## 3. OpenCode 对 SDD 的天然适配点

如果只看 workflow 设计，OpenCode 最适合 SDD 的地方有四个：

### 3.1 有天然的“先计划、后执行”模式切换
Plan / Build 模式几乎就是 SDD 的天然切面。

### 3.2 有 agent / subagent / permission 分层
适合把不同阶段拆成不同角色，而不是一个 agent 既写 spec 又直接乱改代码。

### 3.3 有项目级配置和 prompt 文件机制
适合把 workflow 规则沉淀到仓库，而不是依赖会话记忆。

### 3.4 有 bash / terminal integration
适合复用已有 shell workflow 和生成式脚本。

---

## 4. OpenCode 的限制与注意点

虽然 OpenCode 很适合做 workflow，但有几个现实限制要记住。

### 4.1 它是 runtime，不是 workflow 本身
OpenCode 提供的是：

- agent 运行环境
- 权限系统
- 配置系统
- 工具调用能力

但不会自动给你一个优秀的 SDD 工作流。

也就是说：

- OpenCode 负责“能跑”
- workflow 设计负责“跑得对不对”

### 4.2 如果不做 artifacts，很容易退化回 vibe coding
即使有 Plan 模式，如果没有：

- spec
- plan
- tasks
- validation
- checkpoint

最后还是会退化成：

- 聊两句
- 直接改代码
- 再回来修

这并不是 OpenCode 的锅，而是 workflow 没立住。

### 4.3 permission 不等于 process
权限系统能解决“不能乱改”，但不能解决：

- 需求是否清楚
- 任务是否拆对
- 实现是否偏离 spec
- validation 是否完整

所以 permission 是必要条件，不是充分条件。

---

## 5. 从 workflow 设计角度，OpenCode 值得利用的功能清单

如果后面要在 `opencode/` 下做一套 workflow，我建议优先利用这些能力：

### 必用
- Plan / Build 双 primary agent
- project-level agents 定义
- prompt files
- permission controls
- bash integration

### 推荐用
- explore / read-only subagent
- implementation subagent
- review / validation subagent
- limited-step agents（控制成本和失控风险）

### 可选增强
- shareable sessions
- model 分工（轻模型做计划，重模型做实现）
- project-level init / instructions

---

## 6. 对我们下一步设计 OpenCode workflow 的启发

基于以上能力，适合 OpenCode 的 workflow 不应该是：

- 一个大 prompt
- 一个万能 agent
- 一路直接写代码

而更应该是：

- 一个 orchestrator 风格主流程
- Plan / Build 分离
- 多个阶段化 agent
- 明确 artifact 模板
- implement 前的风险门与 checkpoint
- 按 feature 目录沉淀上下文

也就是说，OpenCode 更适合承载：

> **artifact-driven, phase-specific, permission-aware 的 SDD workflow**

而不是“更炫一点的 vibe coding”。

---

## 7. 结论

如果只问一句：

> OpenCode 适不适合承载一套真正能跑的 SDD workflow？

我的判断是：

**适合，而且比很多只有单 agent / 无权限分层的 coding runtime 更适合。**

原因不是它“更强”，而是它天然具备：

- Plan / Build 分层
- subagent 机制
- project-level agent 配置
- prompt / model / permissions 可配置
- shell / terminal 友好

这些能力恰好和一套健康的 SDD workflow 非常对口。

---

## 8. 依据与判断边界

为了避免这篇文档看起来像“拍脑袋总结”，这里把关键判断和公开依据对齐一下。

### 8.1 关于 OpenCode 的基础能力

以下判断主要来自 OpenCode 官方文档：

- OpenCode 是终端 / 桌面 / IDE 扩展形态的开源 AI coding agent
- 支持安装、初始化、项目内 `/init`
- 支持在项目内生成 `AGENTS.md`
- 支持 Plan mode 与 Build mode 的工作方式
- 支持 `@` 调用与多 agent / subagent 使用

依据链接：
- <https://opencode.ai/docs/>
- <https://opencode.ai/docs/agents/>
- <https://github.com/opencode-ai/opencode>

### 8.2 关于 agent 可配置能力

以下判断主要来自 OpenCode agents 文档：

- agent 支持 `description`、`prompt`、`model`、`temperature`、`steps`
- 支持 primary agent 与 subagent
- 支持 project-level markdown agents（如 `.opencode/agents/*.md`）
- 支持 permissions 控制 `edit` / `bash` / `webfetch`
- 支持对特定 bash 命令做更细粒度权限限制

依据链接：
- <https://opencode.ai/docs/agents/>

### 8.3 关于“OpenCode 适合承载 SDD workflow”的判断

这一条不是 OpenCode 官方原文结论，而是我基于以下事实做的归纳判断：

- OpenCode 有 Plan / Build 分层
- OpenCode 有 agent / subagent / permission 机制
- OpenCode 有项目级配置和 prompt 文件入口
- OpenCode 有 terminal/bash 能力
- 这些能力与 artifact-driven、phase-specific workflow 高度兼容

所以这一条属于：

> **基于官方能力描述做的 workflow 设计判断，而不是官方直接承诺。**

### 8.4 当前文档的可信边界

这篇文档目前是：

- **一手依据**：OpenCode 官方 docs / agents docs / GitHub 项目页
- **二手判断**：我从 workflow 设计角度做的归纳

所以你应该把它理解成：

- 不是 OpenCode 官方产品白皮书
- 也不是已经被我们实战完全证明的最终架构
- 而是用于指导 `opencode/` 目录下 workflow v1 设计的研究性结论

---

## 参考来源

- OpenCode 官方 docs: <https://opencode.ai/docs/>
- OpenCode agents docs: <https://opencode.ai/docs/agents/>
- OpenCode GitHub: <https://github.com/opencode-ai/opencode>
