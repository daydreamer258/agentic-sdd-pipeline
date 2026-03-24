# sdd-validate（验证技能）

## 目的

对照代码执行结果和上游制品审查实施结果，并编写 `08-validation.md`。

---

## 使用时机

当流水线处于**验证（validate）**阶段时使用此技能。

---

## 输入

读取：
- `features/<feature>/01-spec.md`
- `features/<feature>/02-plan.md`
- `features/<feature>/06-tasks.md`
- `features/<feature>/07-implementation-log.md`
- 变更的文件 / 可用的测试输出
- `templates/08-validation.md`

写入：
- `features/<feature>/08-validation.md`

---

## 必须产出

验证制品必须包含：

- 已运行的检查
- 结果
- 规范符合度
- 计划符合度
- 建议

---

## 行为规则

- 验证行为，而不仅仅是代码执行。
- 将实施同时对照规范和计划。
- 明确说明问题是代码层面还是上游制品层面。
- 优先使用可操作的审查语言。

---

## 必须避免

- 将测试通过/失败作为验证的全部
- 在符合度不明确时批准变更
- 隐藏是否需要返工的不确定性

---

## 升级条件

如果出现以下情况，升级：
- 真正的失败源是规范或计划
- 因缺少证据无法完成验证
- 实施行为过于模糊，无法自信地判断

---

## 完成标准

当 `08-validation.md` 给出明确的通过/返工信号并解释原因时，此技能完成。
