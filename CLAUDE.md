@~/.agent-rules/AGENTS.md

## Claude Code Adapter

- Claude Code 专属补充写在这里。

<!-- >>> DeskSide Security Gateway >>> -->
## DeskSide 安全网关协作规范

本机已启用 **DeskSide 安全网关**（全局 Git `pre-commit` / `pre-push` 密钥防泄漏拦截与双出口守护），编写与提交代码时请严格遵守：

1. **提交前白名单预检与主动提示**：当新增或修改的代码、单测 Fixture、文档示例、敏感语义字段或枚举值（如含 `Secret` / `Token` / `Password` / `Key` 字样的常量赋值、假密钥样例、示例数据库 URI 等）可能触发安全网关拦截且确需豁免时，**必须在执行 `git commit` / `git push` 提交代码前主动暂停，提示用户先将其加入白名单**，待用户确认后再执行提交。
2. **提供可直接粘贴的豁免项**：提示用户加白名单时，请一并列出待豁免的**相对文件路径**（如 `Tests/Fixtures/`）或扫描输出的 **`sha256:...` 指纹**（每行一条，引导用户粘贴至 `DeskSide -> 安全网关 -> 策略与规则 -> 白名单豁免` 批量添加；若本机存在 `/Applications/DeskSide.app/Contents/MacOS/deskside-guard`，可先执行 `deskside-guard scan <文件路径>` 预检获取指纹）。
3. **严禁绕过安全网关**：禁止使用 `git commit --no-verify`（`-n`）、`git push --no-verify`、篡改 `core.hooksPath` 或拆分硬编码真实密钥来规避检查；真实凭据一律迁移至环境变量读取。
<!-- <<< DeskSide Security Gateway <<< -->
