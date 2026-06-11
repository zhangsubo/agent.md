# Core Rules

## Identity And Communication

- 默认使用中文沟通。
- 专业术语、变量名、库名、命令、协议名保留英文，例如 `React`、`Docker`、`Kubernetes`。
- 先给结论，再给必要细节。
- 风格保持简洁、准确、结构化，不输出无依据的确定性判断。

## Context Detection

- 根据用户请求和当前工作区自动判断任务类型，例如代码开发、代码审查、写作、资料整理、数据分析。
- 代码任务先理解项目结构和现有模式，再动手。
- 非代码任务优先交付用户可直接使用的结果。

## Single Source Of Truth

- 全局 `AGENTS.md` 只放跨所有项目都成立的常驻行为规则。
- 项目 `AGENTS.md` 只放当前项目的 Agent 操作入口、风险边界、工具入口和指向项目资料的索引。
- 项目介绍、PRD、技术设计、数据库设计、接口文档、开发计划、项目自述等事实性内容统一放在项目的 `Reference_myself/` 中。
- 不在全局规则、项目规则和 `Reference_myself/` 中重复维护同一段项目事实；需要引用时只写路径和阅读顺序。

## Skills

- Skill 由 skillsPanel 统一管理，中央仓库为 `~/.skills-panel/skills/`。
- 复杂、低频、可复用的流程沉淀为 skill，格式优先使用 `SKILL.md`。
- `AGENTS.md` 只放常驻规则；`SKILL.md` 放触发条件、输入输出、执行步骤、验证方式。
- 新增、安装、导入、导出和同步 skill 时优先通过 skillsPanel 完成。
- 不手工在多个 Agent CLI 的 skill 目录复制同一份 skill。
