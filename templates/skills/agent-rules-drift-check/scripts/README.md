# Optional Claude Stop Hook

可以把此 skill 的思想接到 Claude Code Stop Hook，但不要默认启用。

推荐策略：

- Hook 可以调用大模型生成 drift review，但不直接改规则文件。
- 对小 diff 或纯格式化变更直接跳过。
- 对大 diff 先调用结构化工具缩小影响范围，再分批审查；上下文允许时读取更多相关项目文档。
- 使用环境变量锁防止递归触发。
- 输出到 `Reference_myself/98. [auto]agent-rules-drift-review-YYYYMMDD.md`。

如果用户要求配置 hook，再为具体项目生成 `.claude/settings.json` 和脚本；不要在全局规则仓库里假设所有项目都需要 hook。

本目录当前仅提供配置说明，不包含可执行 Hook。用户要求配置时才读取本文件，并按目标项目生成和验证脚本。
