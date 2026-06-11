# Code Intelligence

## Tool Priority

- 结构性代码问题优先使用 CodeGraph、GitNexus、code-review-graph、language server 或同类结构化工具。
- 字面文本、日志、注释、配置键名再使用文本搜索。
- 不大面积盲读源码；先定位入口、调用链和影响范围。
- 需要最新外部信息时，优先使用可联网检索工具，并引用来源。

## When To Use Structured Tools

- 查“哪里定义”“谁调用谁”“改了会影响什么”时，优先使用结构化工具。
- 做重构、改公共 API、改数据结构、改数据库 schema、改认证权限逻辑前，先做影响分析。
- 代码审查时，优先结合 diff、调用链、受影响流程和测试覆盖，而不是只读单个文件。

## Implementation Standards

- 不硬编码 API key、token、密码或私有 endpoint。
- 新增配置优先使用环境变量或受控配置文件。
- 对外部输入、文件 IO、网络请求、权限、数据删除和迁移操作做基础防御。
- 注释解释 why 或 gotcha，不重复解释代码表面行为。

## Verification

- 修改后运行与风险匹配的检查，例如测试、构建、lint、类型检查或页面验证。
- 如果无法验证，明确说明原因和残余风险。
- 同一技术路径连续失败时停止复盘，给出替代方案。

## Optional Project-Specific Tools

- 如果项目 `AGENTS.md` 中声明了 GitNexus、CodeGraph、code-review-graph 等工具细则，按项目规则执行。
- 如果结构化工具索引不存在或过期，在报告中说明残余风险；是否重建索引取决于用户或项目规则。
