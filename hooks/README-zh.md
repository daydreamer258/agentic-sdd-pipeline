# 钩子（Hooks）

本目录包含 v1 SDD 流水线的轻量级钩子骨架。

## 钩子理念

钩子是流水线的自动化粘合剂。
它们应保持小巧、确定性和易于理解。

钩子最适用于：

- 脚手架搭建
- 阶段门控
- 轻量级元数据/状态更新
- 写入后检查
- 验证摘要

钩子应避免成为第二个隐藏的编排器。

## 包含的钩子

- `on_feature_init.sh` — 功能初始化时触发
- `before_stage_transition.sh` — 阶段转换前触发
- `after_artifact_write.sh` — 制品写入后触发
- `before_implement.sh` — 实施前触发
- `after_validation.sh` — 验证后触发

## 预期环境变量

钩子在被包装器/编排器调用时可使用以下变量：

- `FEATURE_DIR` — 功能目录路径
- `FROM_STAGE` — 来源阶段
- `TO_STAGE` — 目标阶段
- `ARTIFACT_PATH` — 制品路径
- `FEATURE_ID` — 功能 ID
- `FEATURE_SLUG` — 功能标识

## 行为模型

### 成功
退出码 `0`

### 阻止 / 失败
退出码非零，并输出清晰的 stderr 消息

## 注意

这些钩子脚本有意保持轻量和保守。
它们旨在使流水线可运行，而非完全自主。
