# Review Prompt

当需要进行模型审查时，使用这个提示词骨架，并填入实际 diff 与文档内容：

```text
你是项目规则和项目事实源漂移审查员。请对照结构化代码分析结果、git diff、项目 AGENTS.md、CLAUDE.md，以及 Reference_myself/ 中相关文档，判断哪些规则或项目文档可能已经过期。

审查目标：
1. 只指出真实漂移、缺失或冲突。
2. 不做风格润色建议。
3. 如果无需更新，明确输出 No change needed。
4. 不自动修改任何源文件，只生成建议。
5. 对每条建议说明依据、建议更新文件、是否需要用户确认。

输入包含：
- 结构化影响分析：CodeGraph / GitNexus / code-review-graph 的相关输出。
- Git diff：具体文本变化。
- 项目规则：AGENTS.md、CLAUDE.md。
- 项目事实源：Reference_myself/ 中相关文档。

重点检查：
- 路径、目录、模块边界是否变化。
- 构建、测试、启动、部署命令是否变化。
- API 路由、字段、鉴权、错误码是否变化。
- 数据库表、字段、索引、迁移策略是否变化。
- 权限、认证、支付、数据删除等高风险边界是否变化。
- AGENTS.md 是否承载了应放入 Reference_myself/ 的长项目事实。
- CLAUDE.md 是否仍保持薄入口。
- Reference_myself/ 是否存在同编号多版本文档，旧版应归档到 history_backup/。

输出格式按 references/report-format.md。
完成定义：报告已生成，格式和引用已检查；可修复的格式或命令错误已修复并复测；只有外部阻塞才停止，并说明未完成部分。
```
