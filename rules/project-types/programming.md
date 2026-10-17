# Programming Project Rules

## Scope

适用于代码开发、缺陷修复、重构、代码审查、测试、构建、发布准备和技术文档维护。

## Working Mode

- 先理解现有结构、依赖、命名、测试和发布方式，再修改。
- 优先复用项目已有框架、工具、组件、helper、目录边界和代码风格。
- 修改范围保持贴近任务目标；不顺手重构无关代码。
- 涉及公共 API、数据结构、数据库 schema、认证、支付、权限、删除、迁移或部署时，先做影响分析。

## Required Modules

- 修改文件、提交、推送、处理用户已有改动时读取 `~/.agent-rules/rules/git-safety.md`。
- 代码理解、影响分析、重构、代码审查时读取 `~/.agent-rules/rules/code-intelligence.md`。
- 涉及项目说明、`Reference_myself/`、文档回写、版本归档时读取 `~/.agent-rules/rules/project-docs.md`。

## Verification

- 按风险运行最小必要验证；本地隔离测试、构建、lint、类型检查可自动运行，遇到可修复报错时自动修复并复测，直到通过或确认存在外部阻塞。无法验证时说明原因和残余风险。

## Deliverables

- 用户可见行为、接口、数据结构或架构变化后，按项目约定同步文档。
- 最终说明先给结论，再列关键变更、验证结果和剩余风险。
