# 从 0 新建 Feature 的中文 Demo

这份文档是给第一次接触这个仓库的人准备的。

目标很直接：

- 从 0 创建一条新的 feature
- 写入一段原始需求
- 在 **Claude Code** 里直接执行命令
- 跑通：

```text
intake -> spec -> plan -> tasks
```

这份 demo 比“复现现有 feature”更像真正第一次上手。

---

## 1. 这个 demo 适合谁

适合你如果你想要的是：

- 不是只看别人跑好的样例
- 而是自己亲手从空白 feature 开始
- 验证这套 lightweight SDD pipeline 到底怎么工作

如果你只是想最快看到效果，优先看另一篇：

- `docs/Claude-Code-中文上手-demo.md`

那篇偏“最快跑通”。

这篇偏“第一次自己从 0 建 feature”。

---

## 2. 这次 demo 要做的 feature 是什么

我给你选一个**中等难度、边界清楚**的任务：

> 为仓库新增一个面向用户的 feature 进度概览增强需求，目标不是直接实现，而是先生成一条结构清晰的 intake / spec / plan / tasks 工件链。

这个任务的好处是：

- 不会太玩具
- 又不会一下子撞到高风险 implement
- 很适合展示这套系统最成熟的能力

---

## 3. 前置条件

在 Claude Code 里开始之前，请先确认：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
command -v claude
ls scripts
```

你需要确保：

- `claude` CLI 可用
- 你在仓库根目录里
- `scripts/` 目录存在

---

## 4. 一把跑通版（最推荐）

如果你想最快从 0 新建并跑通，直接复制下面这一整段到 Claude Code 终端即可。

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline

./scripts/init-feature.sh 007 demo-new-feature "Demo New Feature"

cat > ./features/007-demo-new-feature/request.txt <<'EOF'
Add a lightweight feature request for this repository that improves the feature summary experience for human users. The goal is to make it easier to quickly understand a feature's current stage, status, last artifact, and next expected step. Keep the work compatible with the current shell-based pipeline and focus on producing strong early-stage artifacts: intake, spec, plan, and tasks.
EOF

./scripts/feature-summary.sh ./features/007-demo-new-feature
./scripts/auto-workflow.sh ./features/007-demo-new-feature full intake tasks
./scripts/feature-summary.sh ./features/007-demo-new-feature
ls -la ./features/007-demo-new-feature
```

---

## 5. 这段命令分别做了什么

### 第 1 步：初始化 feature

```sh
./scripts/init-feature.sh 007 demo-new-feature "Demo New Feature"
```

会创建：

```text
features/007-demo-new-feature/
```

并初始化：

- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`
- `state.json`

### 第 2 步：写入原始需求

```sh
cat > ./features/007-demo-new-feature/request.txt <<'EOF'
...
EOF
```

这是给 intake 阶段的原始输入。

### 第 3 步：先看一下初始状态

```sh
./scripts/feature-summary.sh ./features/007-demo-new-feature
```

这时你会看到 feature 已存在，但还没真正完成前面那些工件。

### 第 4 步：自动跑完整早期流程

```sh
./scripts/auto-workflow.sh ./features/007-demo-new-feature full intake tasks
```

这是整套 demo 的核心命令。

它会自动串起来：

1. `execute-stage.sh`
2. backend consumer
3. `complete-artifact.sh`

按顺序推进：

```text
intake -> spec -> plan -> tasks
```

### 第 5 步：再看状态和产物

```sh
./scripts/feature-summary.sh ./features/007-demo-new-feature
ls -la ./features/007-demo-new-feature
```

这是为了确认结果确实落盘了，而不是只在终端里热闹一下。

---

## 6. 跑成功后你应该看到什么

### 终端输出里
大概率会看到类似：

- `Stage prepared: intake`
- `Claude consumer completed stage: intake`
- `Stage transition allowed: spec`
- `Claude consumer completed stage: spec`
- `Claude consumer completed stage: plan`
- `Claude consumer completed stage: tasks`

### `feature-summary.sh` 里
你应该能看到类似：

- `Current stage: tasks`
- `Status: artifact_written`
- `Last artifact: 06-tasks.md`

### feature 目录里
至少会有这些文件：

- `request.txt`
- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `state.json`
- `.runtime/`

如果这些基本齐了，说明 demo 成功。

---

## 7. 如果你想手动逐阶段跑

如果你更想看清楚每一步，而不是一把自动跑完，可以用下面这组命令。

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline

./scripts/init-feature.sh 008 demo-manual-feature "Demo Manual Feature"

cat > ./features/008-demo-manual-feature/request.txt <<'EOF'
Create a manual demo feature for the lightweight SDD pipeline. The goal is to produce a clear intake, spec, plan, and tasks breakdown for a small repository usability improvement.
EOF

./scripts/execute-stage.sh ./features/008-demo-manual-feature intake
./scripts/consume-stage-with-claude.sh ./features/008-demo-manual-feature intake
./scripts/complete-artifact.sh ./features/008-demo-manual-feature 00-intake.md

./scripts/execute-stage.sh ./features/008-demo-manual-feature spec
./scripts/consume-stage-with-claude.sh ./features/008-demo-manual-feature spec
./scripts/complete-artifact.sh ./features/008-demo-manual-feature 01-spec.md

./scripts/execute-stage.sh ./features/008-demo-manual-feature plan
./scripts/consume-stage-with-claude.sh ./features/008-demo-manual-feature plan
./scripts/complete-artifact.sh ./features/008-demo-manual-feature 02-plan.md

./scripts/execute-stage.sh ./features/008-demo-manual-feature tasks
./scripts/consume-stage-with-claude.sh ./features/008-demo-manual-feature tasks
./scripts/complete-artifact.sh ./features/008-demo-manual-feature 06-tasks.md

./scripts/feature-summary.sh ./features/008-demo-manual-feature
```

这种方式更适合理解系统，而不是追求最快。

---

## 8. 为什么这个 demo 不默认跑到 implement

这不是偷懒，是有意控制风险。

因为当前仓库虽然已经支持：

- `implement` consumer
- implement safety policy
- implement checkpoint

但 `implement` 仍然是：

> **bounded / experimental**

所以第一份从 0 新建 feature 的 demo，最合适的终点仍然是：

```text
tasks
```

先把当前最成熟的主干跑顺，再碰 implement。

---

## 9. 如果你非要继续试 implement

你可以这样做：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/auto-workflow.sh ./features/007-demo-new-feature full intake validate
```

但要知道：

- 如果 implement 风险评估结果是 `medium` 或 `high`
- 系统会生成 checkpoint 并停住

这不算失败，而是当前设计故意这样做。

---

## 10. 常见问题

### Q1：如果提示 `claude CLI not found`？
说明当前环境没有可用的 `claude` 命令，先确认安装和 PATH。

### Q2：如果跑到一半提示 Claude 配额限制？
不是 workflow 设计坏了，是 backend 暂时没额度。等额度恢复后重跑。

### Q3：如果我想换一个 feature id？
可以，直接把：

- `007`
- `008`

换成你没占用的新编号即可。

### Q4：如果目录已经存在怎么办？
换一个新的 feature id / slug，不要硬覆盖。

---

## 11. 推荐你第一次就复制的命令

如果你只想要一段最实用的“从 0 开始”命令，就复制这段：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline

./scripts/init-feature.sh 007 demo-new-feature "Demo New Feature"

cat > ./features/007-demo-new-feature/request.txt <<'EOF'
Add a lightweight feature request for this repository that improves the feature summary experience for human users. The goal is to make it easier to quickly understand a feature's current stage, status, last artifact, and next expected step. Keep the work compatible with the current shell-based pipeline and focus on producing strong early-stage artifacts: intake, spec, plan, and tasks.
EOF

./scripts/auto-workflow.sh ./features/007-demo-new-feature full intake tasks
./scripts/feature-summary.sh ./features/007-demo-new-feature
```

这就是当前仓库里最像“第一次自己从 0 建 feature”的中文 demo。
