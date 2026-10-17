---
name: agent-rules-drift-check
description: 当代码、配置、接口、数据库或文档变更可能导致项目规则或事实源失配，或用户明确要求检查规则漂移时调用。
---

# Agent Rules Drift Check

检查实际变更与 Agent 规则、项目事实源是否一致，只输出有证据的建议，不自动修改源文件。

## Inputs

从上下文获取检查范围、实际 diff、项目 AGENTS.md / CLAUDE.md、文档清单和相关事实源；按需补充结构化影响分析。只读取最小必要上下文，自行选择工具与顺序。

## Reference Routing

- 判断是否适用有疑问时：读取 [触发矩阵](references/trigger-matrix.md)。
- 开始审查时：读取 [审查约束](references/review-policy.md)。
- 生成报告时：遵循 [报告格式](references/report-format.md)。
- 需要独立模型审查提示词时：读取 [提示词骨架](references/review-prompt.md)。
- 用户要求配置 Stop Hook 时：读取 [Hook 说明](scripts/README.md)，不默认启用。

## Outputs And Completion

- 默认报告路径：`Reference_myself/98. [auto]agent-rules-drift-review-YYYYMMDD.md`；目录不存在时直接在对话中输出，用户明确要求落盘时使用指定路径。
- 报告属于本地私有项目资料，通常不进入仓库。
- 完成定义：报告已生成，格式和引用已检查；可修复的格式或命令错误已修复并复测；只有外部阻塞才停止，并明确未完成部分与残余风险。
