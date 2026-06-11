# Agent Rules Entry

这是跨 Agent 的主入口文件。保持简洁，只放所有任务都需要立即知道的规则和按需加载索引。

## Always

- 默认使用中文沟通，专业术语、变量名、库名、命令和协议名保留英文。
- 先给结论，再给必要细节；保持简洁、准确、结构化。
- 不输出无依据的确定性判断；不把 token、API key、密码或私有 endpoint 写入规则、文档或提交。
- 修改前尊重用户已有改动，不覆盖、不回退未明确要求的变更。
- 复杂、低频、可复用流程优先沉淀为 `SKILL.md`，不要继续塞进常驻规则。

## Progressive Loading

- 不要一次性读取全部规则文件。
- 先根据用户请求判断任务类型，再只读取相关模块。
- 如果模块之间冲突，优先级为：用户最新指令 > 项目级 `AGENTS.md` > 本文件 > `rules/` 模块。
- 需要项目事实时，优先读取项目 `Reference_myself/00. README.md` 或文档清单；不要把项目事实复制进全局规则。

## Rule Modules

| 任务场景 | 按需读取 |
|---|---|
| 需要更完整的沟通、任务判断、单一事实源原则 | `rules/core.md` |
| 准备修改文件、提交、推送、处理用户已有改动 | `rules/git-safety.md` |
| 代码理解、影响分析、重构、代码审查、结构化工具选择 | `rules/code-intelligence.md` |
| 项目说明、`Reference_myself/`、文档回写、版本归档 | `rules/project-docs.md` |
| 当前模型是 `xiaomi/mimo-2.5-pro` 且任务包含图片/截图/视觉理解 | `rules/mimo-image-bridge.md` |

## Repository Notes

- 本仓库维护 Agent rules 和模板；skills 的长期中心仓库仍是 `~/.skills-panel/skills/`。
- 安装或同步时，`AGENTS.md` 与 `rules/` 必须一起保留，否则按需引用会失效。
