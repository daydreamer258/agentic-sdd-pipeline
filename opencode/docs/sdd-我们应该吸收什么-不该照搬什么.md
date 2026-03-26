# SDD：我们应该吸收什么，不该照搬什么

这篇文档的目标不是再重复介绍一遍 SDD，而是基于以下资料，反向整理出**对我们当前 OpenCode workflow 设计真正有用的结论**：

- Jimmy Song 的 SDD 系列子章节
- GitHub SpecKit 相关资料
- OpenSpec 相关资料
- 以及我们当前 `agentic-sdd-pipeline` 的实践经验

这篇文档重点回答两个问题：

1. 这些 SDD 资料里，哪些内容值得吸收进我们的 workflow？
2. 哪些内容不能直接照搬，否则会把 v1 做重、做僵、做假？

---

## 1. 先说我的总判断

如果只用一句话概括：

> **我们应该吸收 SDD 的“规范中心、阶段化、规则显式化、agent 可操作化”思想，但不应该照搬那些偏重型、偏大一统、偏工具绑定的实现方式。**

更具体一点：

- **该吸收的**：规范中枢、阶段分离、project instructions、rules、skills、审计链路、实现前对齐、验证闭环
- **不该照搬的**：过重的命令体系、过多模板层级、未经验证就全量引入的复杂治理、为了“完整”而引入的文档膨胀

这基本就是我读完这些章节之后最明确的判断。

---

## 2. 应该吸收什么

### 2.1 吸收“规范不是文档，而是工作中枢”

Jimmy Song 的方法论章节强调：

- SDD 是从代码中心转向规范中心
- 规范应该成为需求、设计、生成、验证与交付的唯一真相源
- 规范不只是前置说明，而是贯穿工程闭环

这点我认为**必须吸收**。

因为如果不吸收这一点，我们很容易把 workflow 做成：

- 几个 prompt 文件
- 几个模板
- 然后 agent 还是主要靠会话记忆在工作

那就不是 SDD，只是更有格式的 vibe coding。

### 对我们意味着什么

后面的 OpenCode workflow 必须围绕这些“规范中枢文件”组织：

- intake
- spec
- plan
- tasks
- implementation log
- validation
- （可选）retrospective

这些文件不是“附属文档”，而是 workflow 本体的一部分。

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/methodology/>
- <https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>

---

### 2.2 吸收“Rules / AGENTS.md / Skills 是 workflow 的一部分”

这是这次阅读里对我影响最大的点之一。

Jimmy Song 的几章实际上把 SDD 扩展成了四层东西：

- 规范工件（spec/plan/tasks）
- Rules（规则文件）
- AGENTS.md（智能体工作契约）
- Skills（能力封装与复用）

这很重要，因为它说明：

> **一个真正能跑的 SDD workflow，不只是 artifacts，还必须有 agent-facing instruction layer。**

### 对我们意味着什么

如果我们要在 `opencode/` 下做 workflow，至少应该保留：

- project-level instructions
- role / agent definitions
- rules（尤其边界、命令、验证方式）
- skill / capability 目录化封装

而不能只留下模板。

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/rules/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/agents/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/skills/>
- <https://agentskills.io/home>

---

### 2.3 吸收“implement 前要有对齐与刹车机制”

OpenSpec 和方法论章节都在强调一件事：

- 先对齐，再写代码
- 规范不是束缚，而是人机协作桥梁
- 审计链路和 review 不是附加项，而是 workflow 的一部分

这和我们现在仓库里已经做出来的 implement checkpoint 方向高度一致。

所以我认为：

> **implement checkpoint 不是临时补丁，而应该被视为 OpenCode workflow 的核心设计之一。**

### 对我们意味着什么

后面的 OpenCode v1 应该保留：

- risk assessment
- checkpoint generation
- stop-before-implement for medium/high risk
- validation gate

而不是为了“显得自动化”把刹车拆掉。

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/openspec/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/methodology/>

---

### 2.4 吸收“规范与变更应该可审计”

OpenSpec 章节最值得吸收的一点，不是它的目录长什么样，而是它的思想：

- 当前事实（source of truth）
- 变更提案（delta / proposal / tasks）
- review 后再合并回事实源

这件事很值钱，因为它让 workflow 不是“每次都覆盖当前状态”，而是：

- 当前状态是什么
- 这次想改什么
- 为什么改
- 改完如何归档

都可追踪。

### 对我们意味着什么

我们不一定要照搬 OpenSpec 的完整目录结构，
但应该吸收它的审计思想：

- 规范要区分当前事实与变更意图
- change proposal / delta 思想值得保留
- workflow 不应只有最终文档，没有变更链路

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/openspec/>
- <https://github.com/Fission-AI/OpenSpec>

---

### 2.5 吸收“SpecKit 的阶段化和命令化思想，但保留轻量化取舍”

SpecKit 章节里最值得吸收的，是它清楚地把工作流拆成：

- specify
- clarify
- plan
- analyze
- tasks
- implement
- constitution

并且用：

- templates
- helper scripts
- command system
- governance

去保证 agent 在同一轨道上工作。

这一点非常有启发，因为它说明：

> **好的 workflow 不只是阶段名存在，而是每个阶段都有进入条件、输出产物和自动化支撑。**

### 对我们意味着什么

我们应该保留：

- 明确阶段顺序
- 阶段输出物命名
- 进入下一阶段的前提
- validation / analyze 这一类检查性动作

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/speckit/>
- <https://github.com/github/spec-kit>
- <https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>

---

## 3. 不该照搬什么

### 3.1 不要照搬过重的命令体系

SpecKit 很强，但也很重。

它的命令、模板、脚本、治理层、宪章层非常完整，这对成熟平台是优势，但对我们当前 OpenCode v1 来说，如果一股脑搬过来，大概率会出现：

- 目录很漂亮
- 命令很多
- 但真实跑不动
- 或者维护成本太高

### 我的判断
我们可以吸收它的工作流思想，**但不应该照搬整套命令体系**。

### 对我们意味着什么

不要一开始就上：
- `/clarify`
- `/analyze`
- `/constitution`
- `/archive`
- 多层脚本联动
- 太完整的治理框架

而应该先保留最小闭环。

---

### 3.2 不要照搬“规范即唯一可执行真相”的极端版本

方法论章节提到 spec-as-source，这个方向当然很诱人。

但它同时也提到：

- 多数工具仍停留在 spec-first
- 真正成熟的愿景才是 spec-as-source
- 过度刚性的 workflow 反而可能适得其反

### 我的判断
我们当前更适合：

- **spec-anchored**
- 而不是直接冲向 **spec-as-source**

因为后者意味着：
- 代码大量自动生成
- 大量“不要手改”的约束
- 更强的规范-系统同步机制
- 更高的治理和工具成熟度要求

这对当前 OpenCode v1 来说太重。

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/methodology/>
- <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>

---

### 3.3 不要照搬“所有项目都要完整规范闭环”的刚性要求

Jimmy Song 的方法论章节也提到一个很现实的问题：

- 工作流过刚，小任务也要完整规范，成本高
- Markdown 审核负担大
- 复杂工具可能适得其反

这个提醒特别重要。

### 我的判断
OpenCode workflow v1 一定要允许：

- 小任务轻量走
- 大任务完整走
- 不同风险级别不同流程

而不是不管什么事都要：

- intake
- spec
- plan
- tasks
- implement
- validate
- retrospective
- archive

全套走满。

不然很快会被人嫌烦。

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/methodology/>
- <https://intent-driven.dev/knowledge/best-practices/>

---

### 3.4 不要把 AGENTS.md / Rules 写成“更长的 prompt”

AGENTS.md 那章有句我很认同的话：

> AGENTS.md 不是提示词，而是 Contract。

这句话反过来也是提醒。

### 我的判断
我们不该做的，是把：
- AGENTS.md
- Rules
- Skills

写成三份不同位置的“长 prompt 重复体”。

如果那样做，后果会是：
- 内容冲突
- 难维护
- agent 读了一堆重复话
- 最后没人知道哪个算准

### 对我们意味着什么

后面设计时必须明确分工：

- AGENTS.md：项目级 contract
- Rules：行为准则 / 约束 / 代码风格 / 提交规范
- Skills：任务型能力入口
- Artifacts：当前 feature 的事实源

这四者不能糊成一坨。

依据：
- <https://jimmysong.io/zh/book/ai-handbook/sdd/agents/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/rules/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/skills/>

---

## 4. 这次阅读后，我对 OpenCode workflow 的更新版主张

如果让我基于这次阅读重新压缩成一句话，我现在的主张是：

> **OpenCode v1 应该做成一个 spec-anchored、artifact-driven、rule-aware、agent-operable、implementation-bounded 的 workflow。**

展开就是：

### 应保留
- 核心 artifacts
- project instructions
- rules
- role / agent definitions
- skills / capability packages
- implement checkpoint
- validation gate

### 应暂缓
- 过多 slash commands
- 过重治理层
- 过细的 constitution 体系
- 直接追求 spec-as-source
- 全量自动 archive / delta 编排

---

## 5. 我建议我们在 OpenCode v1 里先保留的最小集合

### 5.1 工件层
- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`

### 5.2 规则层
- `AGENTS.md`
- workflow rules
- implement checkpoint rules
- validation rules

### 5.3 agent 层
- primary: Plan / Build
- subagent: Explore / Planner / Implementer / Validator

### 5.4 能力层
- reusable skill-like directories
- prompt files for stage-specific work

### 5.5 执行层
- feature-scoped directory workflow
- risk assessment before implement
- stop / continue decision points

这套已经足够做一个很有共识基础的 v1。

---

## 6. 依据与判断边界

这篇文档里的结论分三类：

### 一类：直接来自 Jimmy Song 章节的结构性观点
例如：
- Rules / AGENTS.md / Skills 都是 SDD 体系的一部分
- 规范中心而不是代码中心
- spec-first / spec-anchored / spec-as-source 的层级区分

### 二类：来自 SpecKit / OpenSpec 的工程实践启发
例如：
- 阶段化命令与模板体系
- delta / proposal / archive 的审计思路
- governance / analyze / validation 的前置门控意义

### 三类：我基于当前仓库经验做的取舍判断
例如：
- 当前不该照搬太重命令体系
- 当前更适合 spec-anchored 而不是 spec-as-source
- 当前必须保留 implement checkpoint
- 当前要把 AGENTS / Rules / Skills / Artifacts 明确分工

所以这篇文档不是“外部资料原话翻译”，而是：

> **基于外部资料逐章阅读之后，对我们自己的 OpenCode workflow v1 做的设计筛选。**

---

## 7. 参考来源

### Jimmy Song SDD 系列
- <https://jimmysong.io/zh/book/ai-handbook/sdd/rules/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/agents/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/skills/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/speckit/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/openspec/>
- <https://jimmysong.io/zh/book/ai-handbook/sdd/methodology/>

### 外部延伸资料
- <https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>
- <https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/>
- <https://github.com/github/spec-kit>
- <https://github.com/Fission-AI/OpenSpec>
- <https://intent-driven.dev/knowledge/best-practices/>
- <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>
- <https://agentskills.io/home>
