---
name: opencode-migration-plan
description: Detailed migration plan to port agentic-sdd-pipeline from Claude Code CLI to opencode, with phased tasks and dependencies
type: project
---

# opencode 迁移计划

**Why:** 探索将 SDD pipeline 从 Claude Code CLI 迁移到 opencode 运行，利用 opencode 的开源生态和插件系统。
**How to apply:** 按 Phase 顺序执行，关键路径为 1.1 → 1.2 → 3.1 → 3.2/3.3 → 5.1 → 5.2。

---

## 架构变更全景

| 组件 | 当前 | opencode 目标 | 变更级别 |
|------|------|--------------|---------|
| Skills | `skills/sdd-*/SKILL.md` | `.opencode/skills/sdd-*/SKILL.md` | 路径迁移 |
| Subagents | `subagents/*.md` | `.opencode/agents/*.md` | 格式+路径适配 |
| Backend Consumer | `consume-stage-with-claude.sh` (claude CLI) | `consume-stage-with-opencode.sh` (opencode run) | **重写** |
| Hooks | Shell 脚本，编排层手动调用 | JS/TS 插件 + Shell 编排混合 | 重写核心 hooks |
| 编排层 | Shell 脚本 | 保持 Shell 脚本，替换 claude 调用 | 小改 |
| State 管理 | `state.json` + grep/cut | 保持不变 | 无 |
| Templates / Artifacts | Markdown 文件 | 保持不变 | 无 |

---

## Phase 1: 基础设施搭建

### 任务 1.1 — 创建 opencode 项目结构

```
.opencode/
├── config.json
├── skills/
│   ├── sdd-intake/SKILL.md
│   ├── sdd-spec/SKILL.md
│   ├── sdd-plan/SKILL.md
│   ├── sdd-tasks/SKILL.md
│   ├── sdd-implement/SKILL.md
│   └── sdd-validate/SKILL.md
├── agents/
│   ├── intake-writer.md
│   ├── spec-writer.md
│   ├── planner.md
│   ├── task-decomposer.md
│   ├── implementer.md
│   └── validator.md
└── plugins/
    └── sdd-pipeline.ts
```

### 任务 1.2 — 编写 opencode 配置文件 `.opencode/config.json`

- 配置 model provider（Anthropic / OpenAI / 其他）
- 配置 plugin 加载路径
- 配置 shell 和权限模式

---

## Phase 2: Skills 与 Subagents 迁移

### 任务 2.1 — 迁移 Skills

- 将 `skills/sdd-*/SKILL.md` 复制到 `.opencode/skills/sdd-*/SKILL.md`
- 内容无需修改（纯 markdown 指令）
- 验证 opencode 能发现并加载这些 skills

### 任务 2.2 — 适配 Subagents 为 opencode Agents 格式

- 当前格式：自定义 markdown（Role / Read / Write / Goal / Priorities / Must avoid / Escalate）
- 目标格式：opencode agent 定义格式，添加 opencode 要求的元数据字段
- 验证可通过 `@intake-writer` 等方式调用

---

## Phase 3: 核心 — 重写 Backend Consumer

**这是整个迁移最关键的部分。**

### 任务 3.1 — 创建 `scripts/consume-stage-with-opencode.sh`

核心逻辑：

```bash
# 替换原来的 claude CLI 调用
# 原: claude --permission-mode acceptEdits --print "Read prompt..."
# 新: opencode run -q --json "prompt content..."

# 1. 组装 prompt（复用现有逻辑）
#    读取 SKILL.md + subagent.md + template + input artifacts
# 2. 将 prompt 内容内联传给 opencode run
# 3. 处理 opencode 的 JSON 输出
# 4. 验证输出 artifact 已写入
```

### 任务 3.2 — 处理 opencode 的权限模型

- claude CLI 用 `--permission-mode acceptEdits`
- opencode 需要等价配置：允许文件读写操作
- 可能需要在 config 中预设 allowed tools

### 任务 3.3 — 处理 implement 阶段的特殊逻辑

- implement 阶段允许修改仓库代码（不仅仅生成 markdown）
- 需确保 opencode 在该阶段有完整的文件写入权限
- 保留 risk assessment + checkpoint 机制

### 任务 3.4 — 适配 `auto-workflow.sh` 的 consumer 调用

- 修改 `auto-workflow.sh`，支持选择 consumer backend
- 新增环境变量 `SDD_CONSUMER=opencode|claude`（默认 opencode）
- 让两种 consumer 可以共存

---

## Phase 4: Hooks 系统迁移

**策略：混合方案** — 保留 shell 脚本作为编排层 hooks，新增 opencode 插件处理 tool 级别 hooks。

### 任务 4.1 — 保留编排层 hooks（验证兼容）

- `on_feature_init.sh` — 初始化特性目录（编排层调用，与 opencode 无关）
- `before_stage_transition.sh` — 依赖验证（编排层调用）
- `before_implement.sh` — 实现前检查（编排层调用）

### 任务 4.2 — 编写 opencode 插件 `sdd-pipeline.ts`

```typescript
// .opencode/plugins/sdd-pipeline.ts
export default function sddPipeline(context) {
  return {
    hooks: {
      "tool.execute.before": async ({ tool, input }) => {
        // 拦截文件写入，确保只写到正确的 artifact 路径
        if (tool === "write" && !input.path.includes("features/")) {
          return { abort: true, message: "只能写入 features/ 目录" }
        }
      },
      "tool.execute.after": async ({ tool, input, output }) => {
        // artifact 写入后更新 state
        if (tool === "write" && input.path.match(/\d{2}-.*\.md$/)) {
          // 触发 complete-artifact 逻辑
        }
      }
    }
  }
}
```

### 任务 4.3 — 迁移 `after_validation.sh` 逻辑

- 当前：读 `08-validation.md`，解析 pass/rework，更新 state
- 可保留为 shell 脚本（由编排层调用），或移入插件

---

## Phase 5: 集成测试

### 任务 5.1 — 单阶段端到端测试

```bash
./scripts/run-stage.sh ./features/test-001-opencode-migration intake
./scripts/consume-stage-with-opencode.sh ./features/test-001-opencode-migration intake
```

### 任务 5.2 — 全流水线端到端测试

```bash
SDD_CONSUMER=opencode ./scripts/auto-workflow.sh ./features/test-001-opencode-migration full
```

### 任务 5.3 — 双 consumer 对比测试

- 同一 feature 分别用 claude consumer 和 opencode consumer 跑一遍
- 对比 artifact 质量、state 流转、hook 行为

### 任务 5.4 — implement 安全测试

- 创建一个含高风险关键词的 feature
- 验证 risk assessment + checkpoint 机制正常工作

---

## Phase 6: 文档与清理

### 任务 6.1 — 更新 CLAUDE.md / 新增 OPENCODE.md

### 任务 6.2 — 更新 `docs/backend-consumers.md`

### 任务 6.3 — 更新 `scripts/` 下的用法说明

---

## 任务清单总览

| # | 任务 | 优先级 | 复杂度 | 依赖 |
|---|------|--------|--------|------|
| 1.1 | 创建 `.opencode/` 目录结构 | P0 | 低 | — |
| 1.2 | 编写 opencode config.json | P0 | 低 | — |
| 2.1 | 迁移 Skills 到 `.opencode/skills/` | P0 | 低 | 1.1 |
| 2.2 | 适配 Subagents 为 opencode agents 格式 | P1 | 中 | 1.1 |
| **3.1** | **重写 consume-stage-with-opencode.sh** | **P0** | **高** | 1.2 |
| 3.2 | 处理 opencode 权限模型 | P0 | 中 | 3.1 |
| 3.3 | implement 阶段特殊逻辑适配 | P0 | 中 | 3.1 |
| 3.4 | auto-workflow.sh 支持双 consumer | P1 | 低 | 3.1 |
| 4.1 | 保留编排层 hooks（验证兼容） | P1 | 低 | 3.1 |
| 4.2 | 编写 opencode 插件 sdd-pipeline.ts | P1 | 中 | 1.2 |
| 4.3 | 迁移 after_validation 逻辑 | P2 | 低 | 4.2 |
| 5.1 | 单阶段端到端测试 | P0 | 低 | 3.1 |
| 5.2 | 全流水线端到端测试 | P0 | 中 | 5.1 |
| 5.3 | 双 consumer 对比测试 | P2 | 中 | 5.2 |
| 5.4 | implement 安全测试 | P1 | 低 | 5.2 |
| 6.1-6.3 | 文档更新 | P2 | 低 | 5.2 |

**关键路径：** 1.1 → 1.2 → 3.1 → 3.2/3.3 → 5.1 → 5.2

**核心结论：** 迁移难点集中在任务 3.1（重写 backend consumer），其余组件变化极小。项目架构的松耦合设计使迁移可行性高。

---

## 参考资源

- [Plugins | OpenCode](https://opencode.ai/docs/plugins/)
- [CLI | OpenCode](https://opencode.ai/docs/cli/)
- [Config | OpenCode](https://opencode.ai/docs/config/)
- [Agent Skills | OpenCode](https://opencode.ai/docs/skills/)
- [Agents | OpenCode](https://opencode.ai/docs/agents/)
