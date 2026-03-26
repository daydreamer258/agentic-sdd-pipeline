# SDD 优秀工作流实践与模板建议

本文目标是回答三个问题：

1. 一个好的 SDD（Spec-Driven Development）工作流应该包含哪些阶段？
2. 每个阶段应该沉淀哪些工件（artifacts）？
3. 如果要在 OpenCode 上实现一套可运行 workflow，第一版最值得保留的模板和规则是什么？

---

## 1. 先说结论：好的 SDD workflow 不只是“先写 spec”

一个好的 SDD workflow，不应该只停留在：

- 先写文档
- 再让 agent 写代码

真正有用的 SDD workflow，至少应该做到：

- 需求与实现解耦
- 技术决策显式化
- 阶段化推进
- 工件可审阅
- 实现受 spec 约束
- 持续校验实现与 spec 是否漂移
- 在高风险阶段有 checkpoint / 人工 review

如果没有这些，所谓 SDD 很容易退化成：

> “先让 AI 帮我写一篇大文档，然后继续 vibe coding。”

这没什么意义。

---

## 2. 一个优秀的 SDD workflow 应包含哪些阶段

结合公开实践（Spec Kit、Thoughtworks、Intent-Driven 等）和当前仓库经验，我建议一个好的 SDD workflow 至少包含下面这些阶段。

### 2.1 Intake（需求采集）

作用：
- 把原始请求转成结构化问题描述
- 明确目标、约束、非目标
- 过滤掉模糊和范围爆炸的问题

建议产物：
- `00-intake.md`

建议包含：
- 背景 / 问题
- 用户目标
- 输入需求原文
- 约束条件
- 暂不处理内容
- 需要澄清的问题

---

### 2.2 Spec（规格定义）

作用：
- 定义“做什么”和“为什么做”
- 不急着做技术决策
- 形成共享上下文

建议产物：
- `01-spec.md`

建议包含：
- problem statement
- actors / users
- desired behavior
- acceptance criteria
- edge cases
- assumptions
- non-goals

好 spec 的关键不是写很多，而是：

> **必须可审阅、可讨论、可否决。**

---

### 2.3 Plan（技术计划）

作用：
- 定义“怎么做”
- 把 spec 落到技术方案和边界

建议产物：
- `02-plan.md`

建议包含：
- architecture / approach
- relevant files / modules
- interfaces / contracts
- data flow
- implementation order
- constraints / trade-offs
- risks
- validation approach

plan 阶段很重要，因为很多坏 workflow 是从 spec 直接跳 implement，中间缺了“技术约束显式化”。

---

### 2.4 Tasks（任务分解）

作用：
- 把技术计划拆成 agent 可执行的小任务
- 控制并行度和单任务范围

建议产物：
- `06-tasks.md`

建议包含：
- task list
- task dependencies
- task scope boundary
- done criteria
- implementation hints

好的 task 不应该只是“做功能 A/B/C”，而应该尽量做到：

- 小
- 清楚
- 可验证
- 可独立完成

可以借鉴：
- INVEST
- MoSCoW

---

### 2.5 Implement（实施）

作用：
- 基于 spec + plan + tasks 改动真实项目文件

建议产物：
- `07-implementation-log.md`

建议包含：
- attempted tasks
- files changed
- decisions made
- blockers / deviations
- what was not done

这个阶段不建议“完全黑盒执行”。

一个成熟 workflow 应该至少做到：
- task-bound execution
- file scope awareness
- 高风险改动前 checkpoint
- 实施后留痕

---

### 2.6 Validate（验证）

作用：
- 检查实现是否真的符合 spec / plan / tasks
- 避免 spec-implementation drift

建议产物：
- `08-validation.md`

建议包含：
- what was checked
- commands/tests run
- pass/fail summary
- deviations from spec
- unresolved issues

validate 不是“跑一下测试”那么简单。

好的 validate 至少要回答：

- 是否实现了 spec 中的关键行为？
- 是否遗漏重要边界条件？
- 是否出现计划外改动？
- 是否应回退 / 返工？

---

### 2.7 Retrospective（可选但强烈推荐）

作用：
- 复盘工作流本身有没有问题
- 为后续 feature 积累经验

建议产物：
- `09-retrospective.md`

建议包含：
- what worked
- what failed
- prompt / template issues
- workflow bottlenecks
- next improvements

对于 agentic workflow，这一步其实比传统开发更重要，因为：

> **你既在交付功能，也在迭代 workflow 本身。**

---

## 3. 一个好的 SDD workflow 应该具备哪些规则

除了阶段和模板，规则同样关键。

### 3.1 工件优先，不靠会话记忆

workflow 应该围绕 artifacts 运转，而不是围绕“这一轮对话上下文”运转。

因为：
- 会话会压缩
- agent 会丢上下文
- 多 agent / 多 session 必须依赖共享文件

---

### 3.2 阶段必须可阻断

好的 workflow 不应该允许：

- spec 没过就直接 implement
- tasks 没拆清楚就乱写代码
- validate fail 还照样推进

也就是说，应该有 stage gate。

---

### 3.3 implement 必须受控

这是 SDD 是否真的有工程价值的分水岭。

建议 implement 至少包含：

- risk assessment
- checkpoint policy
- bounded scope
- implementation log

否则前面所有 spec/plan/tasks 都可能在 implement 时被一脚踢翻。

---

### 3.4 validate 必须与 spec 对齐

不能只做“能不能跑”。

还要检查：
- 是不是按 spec 跑
- 有没有功能漂移
- 有没有偷偷超范围实现

---

### 3.5 artifacts 必须尽量短小可审阅

优秀实践几乎都强调一点：

> **spec 必须 human-reviewable。**

如果文档大到人根本不想看，那它就不再是 source of truth，而只是 AI 生成的噪音。

---

## 4. 一个“好模板”应该包含哪些字段

下面给一个实用主义版本，不追求花哨，只追求可运行。

### 4.1 intake 模板建议
- 背景
- 原始请求
- 问题定义
- 目标
- 约束
- 非目标
- 待澄清项

### 4.2 spec 模板建议
- 问题陈述
- 用户 / 场景
- 期望行为
- 验收标准
- 边界情况
- 假设
- 不做什么

### 4.3 plan 模板建议
- 技术方案摘要
- 涉及模块/文件
- 数据与接口
- 执行顺序
- 风险与取舍
- 验证方案

### 4.4 tasks 模板建议
- 任务编号
- 任务目标
- 变更范围
- 前置依赖
- 完成标准

### 4.5 implementation log 模板建议
- 尝试了哪些任务
- 改了哪些文件
- 做了哪些决定
- 偏离了什么
- 被什么阻塞

### 4.6 validation 模板建议
- 验证范围
- 执行过的命令
- 验收结果
- 未解决问题
- 是否可推进

---

## 5. 好的 SDD workflow 常见反模式

### 5.1 specification theater
文档很多，但没人认真审。

### 5.2 spec 太大
大到人看不完，agent 也容易 lost in the middle。

### 5.3 直接从 spec 跳实现
中间没有 plan / tasks，最后实现容易漂移。

### 5.4 validate 只是形式主义
只写一句“已验证通过”，没有可追溯依据。

### 5.5 implement 没有边界
最终又回到 vibe coding。

---

## 6. 如果要在 OpenCode 上做第一版 workflow，最值得保留的最小集合

如果我们现在就在 `opencode/` 下做 v1，我建议保留这组最小核心：

### 阶段
- intake
- spec
- plan
- tasks
- implement
- validate

### 模板
- intake template
- spec template
- plan template
- tasks template
- implementation-log template
- validation template

### 规则
- stage order
- stage gate
- artifact naming
- implement checkpoint
- validation gate

### 角色
- orchestrator
- planner
- implementer
- validator
- explorer（可选）

### 支撑物
- project instructions
- agent definitions
- prompt files
- feature directory structure

这套已经足够做一个很像样的 lightweight v1。

---

## 7. 我对“好的 SDD workflow”的最终判断

一个好的 SDD workflow，不是文档越多越好，也不是 agent 越多越好。

真正好的标准是：

- 人能审得动
- agent 能执行得动
- 实现不容易漂移
- 高风险阶段会刹车
- 失败后能追溯
- 产物能复用

所以如果只用一句话概括：

> **好的 SDD workflow = artifact-driven + phase-specific + human-reviewable + implementation-bounded + validation-anchored。**

---

## 8. 对 opencode/workflow 设计的直接启发

如果后面我们要在 `opencode/` 下落地 workflow，我建议不要一开始就追求“很智能”。

更应该先追求：

- 阶段清晰
- 模板稳定
- 产物统一
- 权限边界明确
- implement 有 checkpoint
- validate 能真验证

这比“炫技型多 agent 编排”更值钱。

---

## 9. 依据与判断边界

这篇文档里有两类内容：

- **公开实践总结**：来自 Spec Kit、Intent-Driven、Fowler、Thoughtworks 等资料
- **结合当前仓库经验的归纳判断**：来自我们已经做过的 lightweight shell-based SDD pipeline 经验

为了避免混在一起，这里单独说明。

### 9.1 关于 SDD 为什么要分 spec / plan / tasks

以下结论主要参考 GitHub Spec Kit / Microsoft 的资料：

- `/specify` 负责定义“what / why”
- `/plan` 负责定义“how”
- `/tasks` 负责把 spec + plan 拆成可执行任务
- helper scripts / templates 是 workflow 基础设施的一部分
- constitution / project principles 会影响 plan 和后续实现

依据链接：
- <https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>
- <https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/>
- <https://github.com/github/spec-kit>

### 9.2 关于“spec 必须 human-reviewable、要避免过大文档”

以下结论主要参考 Intent-Driven 的最佳实践：

- 规格必须 human-reviewable
- 要从 minimal spec 开始
- 要 meaningful decomposition
- 要持续校验 spec 与实现是否漂移
- 要避免 specification theater 与 AI-generated bloat

依据链接：
- <https://intent-driven.dev/knowledge/best-practices/>

### 9.3 关于“spec-first 之外，还要持续锚定实现”的判断

以下判断主要来自 Martin Fowler、Thoughtworks 以及公开 SDD 讨论：

- spec 的价值不只是前置规划，还在于后续实现与演进锚点
- plan / tasks / validation 是防止 spec 退化成摆设的必要层
- 没有验证和反馈，spec 很容易与代码漂移

依据链接：
- <https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>
- <https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices>

### 9.4 关于本文给出的阶段模板建议

像下面这些内容：

- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`
- `09-retrospective.md`

以及：

- implement checkpoint
- validation gate
- artifact-first
- stage order

这些并不是直接照搬某一个外部来源，而是：

> **把外部 SDD 实践，与我们当前仓库已经验证过的 lightweight pipeline 经验，合并后整理出的 v1 建议。**

所以这部分应该理解成：

- 有公开实践支撑方向
- 但具体文件命名、阶段切法、模板字段，是我们的工程化整理，不是某篇文章的原句

### 9.5 当前文档的可信边界

这篇文档适合用来：

- 对齐 workflow 设计共识
- 决定 v1 先保留哪些阶段和模板
- 避免过早陷入“多 agent 炫技编排”

但不应该被理解成：

- 已经被业界统一标准化
- 所有项目都必须照这个模板执行
- 这就是唯一正确答案

更准确地说，它是：

> **一份以公开 SDD 实践为依据、结合当前仓库经验整理出的 OpenCode workflow 设计参考。**

---

## 参考来源

- Microsoft / GitHub Spec Kit 相关文章：<https://developer.microsoft.com/blog/spec-driven-development-spec-kit/>
- GitHub Spec Kit 项目：<https://github.com/github/spec-kit>
- GitHub Blog 关于 Spec Kit：<https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/>
- Intent-Driven best practices：<https://intent-driven.dev/knowledge/best-practices/>
- Martin Fowler 关于 SDD 的文章：<https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html>
- Thoughtworks 对 SDD 的观察：<https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices>
