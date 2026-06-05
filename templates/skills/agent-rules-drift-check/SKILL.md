---
name: agent-rules-drift-check
description: 使用大模型结合 git diff、CodeGraph、GitNexus、code-review-graph 等结构化代码工具，检查项目代码、配置、接口、数据库或文档变更后，项目 AGENTS.md、CLAUDE.md、Reference_myself/ 项目事实源是否发生语义漂移。每当用户说“检查规则是否过期”“检查文档是否需要同步”“规则漂移”“文档回写”“提交前检查项目说明”，或在完成较大功能、重构、接口/数据库/配置变更后，都应使用此 skill。优先进行模型审查和结构化影响分析，生成审查建议，不自动修改源规则或项目文档。
---

# Agent Rules Drift Check

## Purpose

这个 skill 用来检查“实际变更”和“Agent 规则 / 项目事实源”是否对齐。

它借鉴 Stop Hook 的思路，但适配当前四层结构：

- 全局 `AGENTS.md`：跨项目常驻行为规则。
- 项目 `AGENTS.md`：项目 Agent 操作入口、风险边界、工具入口、文档索引。
- 项目 `CLAUDE.md`：Claude Code 薄入口和 Claude 专属补充。
- `Reference_myself/`：项目事实源，包含 PRD、技术设计、数据库设计、接口文档、开发计划、项目自述。

默认使用大模型做语义审查，并优先结合可用的结构化代码工具，而不是只做文件名、关键词或纯 diff 检查。用户有足够 token 时，可以多读相关文档来提高判断质量。

不要把这个检查变成自动修改器。它只输出建议，由用户或后续任务决定是否采纳。

## When To Use

使用此 skill 的典型场景：

- 用户要求检查 `AGENTS.md`、`CLAUDE.md` 或项目文档是否过期。
- 完成较大功能、重构、目录迁移、依赖升级、构建命令变化后。
- 修改 API、数据库 schema、权限、认证、支付、数据删除、部署配置后。
- 准备提交前，需要确认项目说明、接口文档、技术设计是否需要回写。
- 发现 Agent 反复误读项目结构、命令、路径或约定，需要检查规则是否缺失。

不适合使用：

- 只改错别字、纯格式化、无项目语义变化的小改动。
- 用户明确只想要代码 diff review，不想检查项目文档。

## Inputs

尽量从本地上下文自动收集，并把关键内容交给大模型综合判断：

- 当前 git diff，包括 unstaged、staged，以及必要时和目标分支的 compare diff。
- 改动文件列表。
- 可用的结构化代码分析结果：
  - CodeGraph：相关符号、调用关系、影响范围、文件结构。
  - GitNexus：变更符号、blast radius、受影响 execution flows、API route impact。
  - code-review-graph：风险评分、affected flows、impact radius、review context、test coverage gaps。
- 项目 `AGENTS.md` 和 `CLAUDE.md`。
- `Reference_myself/00. README.md` 或类似文档清单。
- `Reference_myself/99. [auto]项目自述-*.md`。
- 与变更类型相关的项目事实文档：
  - 产品行为变化：`01. PRD-*.md`
  - 架构/模块变化：`02. 技术设计文档-*.md`
  - 数据库变化：`03. 数据库设计文档-*.md`
  - API 变化：`04. 接口文档-*.md`
  - 计划/任务变化：`05. 开发计划-*.md`

如果 `Reference_myself/` 不存在，不要创建一堆文档。只在报告中建议是否需要初始化项目事实源。

## Model Review Policy

- 优先使用大模型审查结构化影响分析、diff 与项目事实源之间的语义一致性。
- token 充足时，允许读取更多相关文档，而不是只看文件名。
- 仍然避免无边界全量读取：先读 `Reference_myself/00. README.md` 或文档清单，再按变更类型选择文档。
- 如果 diff 很大，先按文件类型和变更主题分组，再分批审查。
- 对每个发现给出依据：引用变更点、相关文档、为什么判断为漂移。
- 明确区分“必须更新”“建议更新”“无需更新”。
- 不要因为模型想产出内容就强行给建议；没有漂移时输出 `No change needed`。

## Structural Context Policy

如果项目配置了结构化代码工具，先使用它们收集“变化影响了什么”，再让大模型判断“哪些文档或规则应该同步”。

优先级：

1. GitNexus：适合查变更符号、调用方、执行流程、API route 消费方、跨模块影响。
2. code-review-graph：适合查 review 风险、impact radius、affected flows、测试覆盖缺口。
3. CodeGraph：适合查符号定义、调用关系、影响范围、文件结构。
4. git diff：用于查看具体文本变化和最终事实依据。

使用原则：

- 不要为了形式同时调用所有工具；根据项目可用性和任务类型选择。
- 结构性问题优先使用图谱工具，不先用文本搜索大面积扫代码。
- 如果工具提示索引不存在或过期，在报告中记录残余风险；是否重建索引取决于用户或项目规则。
- 工具结论不是最终报告，最终报告要把“结构化影响 + 项目事实源”合并判断。

## Workflow

1. 确认项目根目录和 git 状态。
2. 收集变更文件列表和 diff。
3. 使用可用的 CodeGraph、GitNexus、code-review-graph 等工具分析变更影响范围。
4. 按变更类型和结构化影响判断可能影响的事实源。
5. 读取最小必要文档，不要全量读取整个 `Reference_myself/`。
6. 使用大模型对照结构化影响分析、diff、项目 `AGENTS.md`、`CLAUDE.md` 和相关 `Reference_myself/` 文档，检查这些问题：
   - 路径、文件名、目录角色是否变了但文档没更新。
   - `Reference_myself/` 根目录是否存在同一个编号但日期或版本不一致的文档；若存在，建议将旧文件移动到 `Reference_myself/history_backup/`。
   - 构建、测试、启动、部署命令是否变了但入口文档没更新。
   - API 路由、请求/响应字段、鉴权规则是否变了但接口文档没更新。
   - 数据表、字段、索引、迁移策略是否变了但数据库文档没更新。
   - 权限、认证、支付、数据删除等高风险边界是否变了但项目 `AGENTS.md` 没更新。
   - Agent 可能误判的 gotcha 是否应该写入项目 `AGENTS.md` 的 `Known Gotchas`。
   - 项目 `CLAUDE.md` 是否仍保持薄入口，是否意外承载了项目事实。
7. 生成 drift review 报告。
8. 不自动修改源文件。除非用户之后明确要求采纳某条建议，再进行定向修改。

## Output Location

默认把报告写到：

```text
Reference_myself/98. [auto]agent-rules-drift-review-YYYYMMDD.md
```

如果 `Reference_myself/` 不存在，先询问用户是否创建；若用户不希望创建，则直接在对话中输出报告。

报告文件属于本地私有项目资料，通常不进入仓库。

## Report Format

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

## Suggested Review Prompt

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

输出格式按 Report Format。
```

## Optional Claude Stop Hook

可以把此 skill 的思想接到 Claude Code Stop Hook，但不要默认启用。

推荐策略：

- Hook 可以调用大模型生成 drift review，但不直接改规则文件。
- 对小 diff 或纯格式化变更直接跳过。
- 对大 diff 先调用结构化工具缩小影响范围，再分批审查；token 允许时读取更多相关项目文档。
- 使用环境变量锁防止递归触发。
- 输出到 `Reference_myself/98. [auto]agent-rules-drift-review-YYYYMMDD.md`。

如果用户要求配置 hook，再为具体项目生成 `.claude/settings.json` 和脚本；不要在全局规则仓库里假设所有项目都需要 hook。
