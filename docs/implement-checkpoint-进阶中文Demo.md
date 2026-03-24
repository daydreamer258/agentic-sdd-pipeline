# implement checkpoint 进阶中文 Demo

这份文档给已经跑过基础 demo 的人看。

如果前两篇文档解决的是：

- 怎么跑通 `intake -> spec -> plan -> tasks`
- 怎么从 0 新建一条 feature

那这篇解决的是：

> **为什么自动 workflow 到了 `implement` 有时候会停住？停住后我该怎么看、怎么判断、怎么继续？**

这就是当前仓库里 `implement checkpoint` 的核心用途。

---

## 1. 这篇 demo 的目标

你会实际体验到：

- `implement` 不是无脑自动执行
- `auto-workflow.sh` 在进入 `implement` 前会做风险评估
- 如果风险是 `medium` 或 `high`
- 系统会生成 `implement-checkpoint.md` 并停住

换句话说，这篇 demo 的目标不是“跑通 implement”，而是：

> **亲手看到 implement checkpoint 如何被触发。**

---

## 2. 当前真实设计是怎样的

仓库当前对 `implement` 的定位是：

- 已接入自动 consumer
- 已纳入 workflow
- 但仍然是 **bounded / experimental**

同时，`implement` 前会经过：

- `scripts/assess-implement-risk.sh`
- `scripts/implement-checkpoint.sh`

### 当前规则
- `low` → 允许继续自动 implement
- `medium` → 生成 checkpoint 并停止
- `high` → 生成 checkpoint / 要求人工 review

所以，**停住不是坏掉，而是设计本身。**

---

## 3. 最简单的理解方式

前面的自动流程：

```text
intake -> spec -> plan -> tasks
```

主要是在生成文档工件。

而 `implement` 开始会真的碰代码、脚本和行为改动。风险完全不是一个级别。

所以系统故意在这里多了一道闸：

```text
tasks -> risk assessment -> implement or checkpoint
```

---

## 4. 这次 demo 怎么选任务

为了稳定触发 checkpoint，我建议你故意给一个**中高风险关键词明显**的需求。

例如：

> 新增一个 feature，要求重构现有逻辑、跨多个模块修改，并涉及 deploy / auth / permission 相关描述。

这样当前仓库里的启发式风险脚本更容易判成：

- `medium`
- 或 `high`

从而稳定演示 checkpoint。

---

## 5. 一把触发 checkpoint 的推荐命令

你可以直接在 **Claude Code** 里执行下面这一整段。

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline

./scripts/init-feature.sh 009 demo-implement-checkpoint "Implement Checkpoint Demo"

cat > ./features/009-demo-implement-checkpoint/request.txt <<'EOF'
Add a risky implementation-oriented feature for this repository. The work should refactor existing logic across multiple modules, touch permission-related behavior, and consider deploy implications. The goal is to produce intake, spec, plan, and tasks first, and then exercise the implement checkpoint behavior rather than actually forcing implementation through.
EOF

./scripts/auto-workflow.sh ./features/009-demo-implement-checkpoint full intake tasks
./scripts/feature-summary.sh ./features/009-demo-implement-checkpoint
./scripts/assess-implement-risk.sh ./features/009-demo-implement-checkpoint
./scripts/auto-workflow.sh ./features/009-demo-implement-checkpoint full intake validate || true
ls -la ./features/009-demo-implement-checkpoint
```

---

## 6. 这段命令分别做了什么

### 第 1 步：新建 feature

```sh
./scripts/init-feature.sh 009 demo-implement-checkpoint "Implement Checkpoint Demo"
```

创建：

- `features/009-demo-implement-checkpoint/`

### 第 2 步：写入一个高风险倾向的需求

```sh
cat > ./features/009-demo-implement-checkpoint/request.txt <<'EOF'
...
EOF
```

这里故意包含一些关键词，例如：

- `refactor`
- `multiple modules`
- `permission`
- `deploy`

因为当前 `assess-implement-risk.sh` 就是基于这些启发式信号判断风险。

### 第 3 步：先跑到 `tasks`

```sh
./scripts/auto-workflow.sh ./features/009-demo-implement-checkpoint full intake tasks
```

这是为了先把早期主干跑完，让后面的 implement 风险判断有输入可读：

- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`

### 第 4 步：单独看风险评估结果

```sh
./scripts/assess-implement-risk.sh ./features/009-demo-implement-checkpoint
```

你大概率会看到类似：

```text
risk=high
reason=matched high-risk keywords
```

或者：

```text
risk=medium
reason=matched medium-risk keywords
```

### 第 5 步：故意尝试跑到 validate

```sh
./scripts/auto-workflow.sh ./features/009-demo-implement-checkpoint full intake validate || true
```

这里的重点不是为了成功跑到 `validate`。

重点是为了让 workflow 真正触发到：

- `implement`
- 风险评估
- checkpoint 生成
- 自动停住

`|| true` 的作用只是：

- 避免 Claude Code 因为命令非 0 退出码而直接中断后续观察

因为当前 checkpoint 触发后，workflow 停止本来就是预期行为。

---

## 7. 你应该看到什么

### 1）风险评估脚本输出

类似：

```text
risk=medium
reason=matched medium-risk keywords
```

或：

```text
risk=high
reason=matched high-risk keywords
```

### 2）workflow 输出中出现 checkpoint 提示

类似：

```text
Implement checkpoint required: ./features/009-demo-implement-checkpoint/implement-checkpoint.md
```

### 3）feature 目录里多了一个文件

你应该能看到：

- `implement-checkpoint.md`

这就是这篇 demo 最核心的观测点。

---

## 8. `implement-checkpoint.md` 长什么样

当前仓库里的 checkpoint 文件会包含：

- feature 名称
- stage: `implement`
- risk 等级
- suggested action
- 一段说明文字

你可以直接查看：

```sh
cat ./features/009-demo-implement-checkpoint/implement-checkpoint.md
```

当前它不会是特别华丽的富摘要，而是一个**故意保持轻量、够用、可读**的暂停说明。

---

## 9. 停在 checkpoint 之后怎么理解

这里最重要的一点是：

> **checkpoint 不是失败，它是结构化暂停。**

这说明系统已经判断：

- 继续自动 implement 风险过高
- 不应该悄悄往下跑
- 应该把决定权交回给人

这正是当前策略想要的效果。

---

## 10. 停住后怎么处理

当前仓库还没有做出特别豪华的“审批后继续”交互层，所以现在的处理方式偏朴素：

### 你可以做的事

#### 方案 A：人工查看 checkpoint
看：

- `implement-checkpoint.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`

判断这个实现任务是不是该继续。

#### 方案 B：修改需求 / 降低风险后重跑
如果你的需求里充满：

- auth
- permission
- deploy
- refactor
- multiple modules

你可以把需求缩小，改成更 bounded 的版本，再重新生成前面工件。

#### 方案 C：人工接管 implement
也就是：

- 把自动化停在 tasks / checkpoint
- 人自己审一遍再决定怎么写代码

这其实很符合当前阶段的成熟度。

---

## 11. 你也可以单独测试 checkpoint 生成脚本

如果你不想每次都整条 workflow 走一遍，也可以直接手工调用：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/implement-checkpoint.sh ./features/009-demo-implement-checkpoint high
cat ./features/009-demo-implement-checkpoint/implement-checkpoint.md
```

这样可以直接看 checkpoint 文件长什么样。

---

## 12. 为什么这篇 demo 有意义

因为很多人看到自动 workflow 时，脑子里会默认以为：

> 自动化 = 一路自动冲到底

但当前这个仓库想表达的是另一种工程观：

> **自动化应该在合适的地方刹车。**

而 `implement checkpoint` 就是这个“刹车系统”的第一版。

它不华丽，但方向是对的。

---

## 13. 最推荐你复制的最小命令组合

如果你只想最快感受 checkpoint，复制这段就够了：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline

./scripts/init-feature.sh 009 demo-implement-checkpoint "Implement Checkpoint Demo"

cat > ./features/009-demo-implement-checkpoint/request.txt <<'EOF'
Add a risky implementation-oriented feature for this repository. The work should refactor existing logic across multiple modules, touch permission-related behavior, and consider deploy implications. The goal is to produce intake, spec, plan, and tasks first, and then exercise the implement checkpoint behavior rather than actually forcing implementation through.
EOF

./scripts/auto-workflow.sh ./features/009-demo-implement-checkpoint full intake tasks
./scripts/assess-implement-risk.sh ./features/009-demo-implement-checkpoint
./scripts/auto-workflow.sh ./features/009-demo-implement-checkpoint full intake validate || true
cat ./features/009-demo-implement-checkpoint/implement-checkpoint.md
```

这就是当前仓库里最标准的 implement checkpoint 进阶中文 demo。
