# Agent Rules Entry

这是跨 Agent 的主入口文件。保持简洁，只放所有任务都需要立即知道的规则和按需加载索引。

## Always

- 默认使用中文沟通，专业术语、变量名、库名、命令和协议名保留英文。
- 先给结论，再给必要细节；保持简洁、准确、结构化。
- 不输出无依据的确定性判断；不把 token、API key、密码或私有 endpoint 写入规则、文档或提交。
- 修改前尊重用户已有改动，不覆盖、不回退未明确要求的变更。
- 复杂、低频、可复用流程优先沉淀为 `SKILL.md`，不要继续塞进常驻规则。

## Progressive Loading

- 全局规则根目录固定为 `~/.agent-rules/`。读取前将 `~` 展开为当前用户主目录，向文件工具传入完整绝对路径；不要相对于工作目录或 `AGENTS.md` / `CLAUDE.md` 软链接所在目录解析。
- 本入口及模块中的全局规则、模板均从该根目录读取；项目 `Reference_myself/` 等资料路径仍相对于项目根目录。若全局文件缺失，报告实际尝试的绝对路径，不要改到 Agent 配置目录寻找同名文件。
- 不要一次性读取全部规则文件。
- 先根据用户请求判断任务类型，再只读取相关模块。
- 进入一个目录且没有项目级 `AGENTS.md`、`CLAUDE.md` 或同类 Agent 入口时，先读取 `~/.agent-rules/rules/project-init.md`，引导用户完成项目初始化。
- 如果模块之间冲突，优先级为：用户最新指令 > 项目级 `AGENTS.md` > 本文件 > `rules/` 模块。
- 需要项目事实时，优先读取项目 `Reference_myself/00. README.md` 或文档清单；不要把项目事实复制进全局规则。

## Project Type

- 默认项目类型是软件开发；若项目级 `AGENTS.md`、用户指令或工作区内容表明是其他类型，先读取对应项目类型规则。
- 项目类型规则只定义工作方式、交付物和质量标准；具体项目事实仍以项目文档为准。

| 项目类型 | 按需读取 |
|---|---|
| 软件开发：开发、调试、重构、测试、发布 | `~/.agent-rules/rules/project-types/programming.md` |
| 产品设计：需求收集、PRD、用户故事、原型说明 | `~/.agent-rules/rules/project-types/product-manager.md` |
| 自媒体工作：公众号写作、小红书图文、选题、内容日历 | `~/.agent-rules/rules/project-types/content-creator.md` |

## Rule Modules

| 任务场景 | 按需读取 |
|---|---|
| 需要更完整的沟通、任务判断、单一事实源原则 | `~/.agent-rules/rules/core.md` |
| 目录缺少项目级 Agent 入口，或用户要求初始化/补全项目初始化 | `~/.agent-rules/rules/project-init.md` |
| 准备修改文件、提交、推送、处理用户已有改动或创建/清理 worktree | `~/.agent-rules/rules/git-safety.md` |
| 代码理解、影响分析、重构、代码审查、结构化工具选择 | `~/.agent-rules/rules/code-intelligence.md` |
| 项目说明、`Reference_myself/`、文档回写、版本归档 | `~/.agent-rules/rules/project-docs.md` |
| 当前模型是 `xiaomi/mimo-2.5-pro` 且任务包含图片/截图/视觉理解 | `~/.agent-rules/rules/mimo-image-bridge.md` |

## Repository Notes

- 本仓库维护 Agent rules 和模板；skills 的长期中心仓库仍是 `~/.skills-panel/skills/`。
- 安装或同步时，主入口和模块必须保留在 `~/.agent-rules/` 下；各 Agent 的入口可以是软链接，无需在 Agent 配置目录复制 `rules/`。

<!-- >>> DeskSide Security Gateway >>> -->
## DeskSide 安全网关协作规范

本机已启用 **DeskSide 安全网关**（全局 Git `pre-commit` / `pre-push` 密钥防泄漏拦截与双出口守护），编写与提交代码时请严格遵守：

1. **提交前白名单预检与主动提示**：当新增或修改的代码、单测 Fixture、文档示例、敏感语义字段或枚举值（如含 `Secret` / `Token` / `Password` / `Key` 字样的常量赋值、假密钥样例、示例数据库 URI 等）可能触发安全网关拦截且确需豁免时，**必须在执行 `git commit` / `git push` 提交代码前主动暂停，提示用户先将其加入白名单**，待用户确认后再执行提交。
2. **提供可直接粘贴的豁免项**：提示用户加白名单时，请一并列出待豁免的**相对文件路径**（如 `Tests/Fixtures/`）或扫描输出的 **`sha256:...` 指纹**（每行一条，引导用户粘贴至 `DeskSide -> 安全网关 -> 策略与规则 -> 白名单豁免` 批量添加；若本机存在 `/Applications/DeskSide.app/Contents/MacOS/deskside-guard`，可先执行 `deskside-guard scan <文件路径>` 预检获取指纹）。
3. **严禁绕过安全网关**：禁止使用 `git commit --no-verify`（`-n`）、`git push --no-verify`、篡改 `core.hooksPath` 或拆分硬编码真实密钥来规避检查；真实凭据一律迁移至环境变量读取。
<!-- <<< DeskSide Security Gateway <<< -->
