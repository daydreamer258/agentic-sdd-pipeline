# Claude Code 中文上手 Demo

这是一份给 **Claude Code** 使用者准备的中文上手示例。

目标不是讲概念，而是让你在这个仓库里：

- 选一个真实能跑通的 demo
- 直接复制命令到 Claude Code 终端里执行
- 看到 `intake -> spec -> plan -> tasks` 的自动链路

---

## 1. 这个 demo 会做什么

本 demo 复用仓库里已经存在的一条真实 feature：

- `features/006-auto-workflow/`

它对应的任务大意是：

> 为当前 SDD pipeline 增加一个自动 workflow runner，支持完整执行、单阶段执行和阶段区间执行。

这条 feature 适合作为 demo，原因很简单：

- 难度适中，不是玩具例子
- 已经有真实 `request.txt`
- 已经验证过 `intake -> tasks` 这条链
- 不需要一开始就碰高风险 implement 自动化

---

## 2. 你会看到什么结果

跑完之后，你会在 `features/006-auto-workflow/` 下看到这些关键工件：

- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `state.json`
- `.runtime/*.bundle.md`
- `.runtime/*.claude-prompt.txt`

这就说明系统已经把：

```text
需求 -> intake -> spec -> plan -> tasks
```

串起来了。

---

## 3. 前置条件

在跑 demo 前，请先确认：

### 必要条件
- 你已经在本机安装了 `claude` CLI
- 当前 shell 可以直接运行 `claude`
- 仓库已经 clone 到本地
- 你当前就在仓库根目录里

### 建议确认命令

```sh
pwd
command -v claude
ls scripts
```

如果这三个都正常，基本就可以继续。

---

## 4. 最推荐的跑法：直接复现现有 demo

这是最稳的方式。

### 在 Claude Code 里直接执行

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/feature-summary.sh ./features/006-auto-workflow
./scripts/auto-workflow.sh ./features/006-auto-workflow full intake tasks
./scripts/feature-summary.sh ./features/006-auto-workflow
```

### 你应该看到什么

重点看两件事：

#### 1）命令输出里会出现阶段推进
例如：
- `Stage prepared: intake`
- `Claude consumer completed stage: intake`
- `Stage transition allowed: spec`
- `Claude consumer completed stage: spec`
- `Claude consumer completed stage: plan`
- `Claude consumer completed stage: tasks`

#### 2）最终 `feature-summary.sh` 会显示状态前进
你应该能看到类似：
- `current_stage: tasks`
- `last_artifact: 06-tasks.md`
- `next_stage: implement`

如果这三项基本对上，就说明 demo 成功了。

---

## 5. 如果你想从头创建一条新的 demo feature

如果你不想只复现现有 feature，也可以新建一条新的 demo 线。

这里给你一个适中的例子：

> 创建一个“feature 状态摘要脚本增强”的需求，并自动跑到 tasks 阶段。

### 第一步：初始化 feature

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/init-feature.sh 007 demo-claude-quickstart "Claude Code Quickstart Demo"
```

### 第二步：写入原始需求

```sh
cat > ./features/007-demo-claude-quickstart/request.txt <<'EOF'
Add a small demo feature for this repository. The feature should improve the feature summary experience so users can quickly understand a feature's current stage, last artifact, and next stage. Keep the scope lightweight and suitable for the existing shell-based pipeline. The goal of this demo is not implementation yet, but to generate a solid intake, spec, plan, and task breakdown.
EOF
```

### 第三步：直接跑完整早期流程

```sh
./scripts/auto-workflow.sh ./features/007-demo-claude-quickstart full intake tasks
```

### 第四步：查看结果

```sh
./scripts/feature-summary.sh ./features/007-demo-claude-quickstart
ls -la ./features/007-demo-claude-quickstart
```

---

## 6. 如果你想逐阶段手动跑

如果你想更看清楚系统是怎么走的，不想一把梭自动跑，也可以这样。

### 逐阶段执行示例

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline

./scripts/execute-stage.sh ./features/007-demo-claude-quickstart intake
./scripts/consume-stage-with-claude.sh ./features/007-demo-claude-quickstart intake
./scripts/complete-artifact.sh ./features/007-demo-claude-quickstart 00-intake.md

./scripts/execute-stage.sh ./features/007-demo-claude-quickstart spec
./scripts/consume-stage-with-claude.sh ./features/007-demo-claude-quickstart spec
./scripts/complete-artifact.sh ./features/007-demo-claude-quickstart 01-spec.md

./scripts/execute-stage.sh ./features/007-demo-claude-quickstart plan
./scripts/consume-stage-with-claude.sh ./features/007-demo-claude-quickstart plan
./scripts/complete-artifact.sh ./features/007-demo-claude-quickstart 02-plan.md

./scripts/execute-stage.sh ./features/007-demo-claude-quickstart tasks
./scripts/consume-stage-with-claude.sh ./features/007-demo-claude-quickstart tasks
./scripts/complete-artifact.sh ./features/007-demo-claude-quickstart 06-tasks.md
```

这种方式更啰嗦，但很好排障。

---

## 7. Claude Code 里最值得先试的命令组合

如果你只想记住一套最实用的命令，记这个就够了：

### 组合 A：直接跑一条完整早期流程

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/auto-workflow.sh ./features/006-auto-workflow full intake tasks
```

### 组合 B：手动跑单个阶段

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/execute-stage.sh ./features/006-auto-workflow spec
./scripts/consume-stage-with-claude.sh ./features/006-auto-workflow spec
./scripts/complete-artifact.sh ./features/006-auto-workflow 01-spec.md
```

### 组合 C：查看当前 feature 到哪了

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/feature-summary.sh ./features/006-auto-workflow
```

---

## 8. 这个 demo 故意没有默认带 implement

这是有意设计的，不是漏了。

原因是：

- 当前仓库里 `implement` 已经接线
- 但它仍然是 **bounded / experimental**
- 并且 implement 现在受 risk assessment / checkpoint 控制

所以更适合先把 demo 放在：

```text
intake -> spec -> plan -> tasks
```

先让你把主干体验跑通，再碰 implement。

---

## 9. 如果你硬要试 implement

可以，但请知道当前定位：

- `implement` 已接入 consumer
- `auto-workflow.sh` 会在 implement 前做风险评估
- 风险为 `medium/high` 时会生成 checkpoint 并停住

你可以自己尝试：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/auto-workflow.sh ./features/006-auto-workflow full intake validate
```

但如果它在 `implement` 前停下，这是**符合设计预期**的，不算坏掉。

---

## 10. 常见问题

### Q1：如果报 `claude CLI not found` 怎么办？
说明当前环境没有可用的 `claude` 命令。先安装或确认 PATH。

### Q2：如果报 Claude 配额限制怎么办？
不是 workflow 设计坏了，是 backend 暂时没额度。等额度恢复后重跑即可。

### Q3：如果看到某次 README patch failed 怎么办？
一般只是中途某次精确替换没贴上，不代表最终仓库状态失败。看最新提交和仓库实际文件更准。

### Q4：这个 demo 最推荐先看哪个 feature？
先看：

- `features/006-auto-workflow/`

它是当前最适合做 Claude Code 上手演示的 feature。

---

## 11. 一句话总结

如果你只想最快感受这个仓库现在到底能不能跑，直接在 Claude Code 里执行：

```sh
cd ~/.openclaw/workspace/repos/agentic-sdd-pipeline
./scripts/auto-workflow.sh ./features/006-auto-workflow full intake tasks
./scripts/feature-summary.sh ./features/006-auto-workflow
```

这就是当前最干净、最真实、最不容易翻车的中文上手 demo。
