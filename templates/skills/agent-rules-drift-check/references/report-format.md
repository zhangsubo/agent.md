# Report Format

使用以下格式：

```md
# Agent Rules Drift Review - YYYY-MM-DD

## Summary

- 检查范围：
- 变更类型：
- 总体结论：No change needed / Needs writeback / Needs user decision

## Findings

### P1 / P2 / P3 - 标题

- 变更依据：
- 可能过期的文件：
- 建议动作：
- 是否需要用户确认：

## No Change Needed

- 已检查但无需更新的文件或规则：

## Suggested Writeback Plan

1. 更新：
2. 不更新：
3. 需要用户判断：

## Residual Risk

- 未读取或无法验证的上下文：
```

## Severity

- `P1`：规则或事实源明显错误，会误导后续 Agent，或涉及安全/权限/数据风险。
- `P2`：文档缺失或局部过期，可能导致返工或误解。
- `P3`：可选优化，例如补充 gotcha、改善阅读路径、减少歧义。

## Decision Rules

- 如果只是代码内部实现变化，且不影响项目事实、命令、接口、数据库、风险边界，可以输出 `No change needed`。
- 如果变更只影响 `Reference_myself/`，不要再建议同步回 `AGENTS.md`，除非涉及 Agent 每次执行都必须知道的边界。
- 如果项目事实已经在 `Reference_myself/` 中更新，不要建议复制到项目 `AGENTS.md`。
- 如果项目 `AGENTS.md` 和 `Reference_myself/` 内容重复，优先建议删除项目 `AGENTS.md` 中的重复长说明，只保留路径和阅读顺序。
- 如果 `CLAUDE.md` 出现项目背景、技术栈、命令等通用内容，建议迁移到 `AGENTS.md` 或 `Reference_myself/`，保持薄入口。
- 如果 `Reference_myself/` 根目录存在同编号文档的多个日期/版本，最新版本保留在根目录，旧版本移动到 `Reference_myself/history_backup/`；不要删除旧版。
