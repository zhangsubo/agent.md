# Project Documentation

## Reference_myself

- 所有没有特别要求存放位置的项目说明文件、代码 review 文件等，默认放到项目 `Reference_myself/` 中。
- 代码类项目应维护一份面向 Agent 的项目说明。
- 推荐路径：`Reference_myself/[auto]项目名称.md`。
- 功能性修改、架构调整、接口变化、数据库变化后，同步更新 `Reference_myself/` 中对应文档；如果项目已有更合适的文档约定，遵循项目约定。

## Versioning

- `Reference_myself/` 中如果出现同一个编号但日期或版本不一致的文档，只保留最新文件在根目录。
- 旧文件移动到 `Reference_myself/history_backup/` 留档，不要删除旧版。
- `00. README.md` 只做文档清单和阅读路径，不承载长篇项目事实。

## Writeback

- 如果不确定该更新哪份文档，先写入 `Reference_myself/99. [auto]项目自述-*.md` 或待整理记录，避免关键信息只留在聊天中。
- 项目公开文档和 `Reference_myself/` 的边界要保持清楚：公开文档面向团队/用户，`Reference_myself/` 面向个人和 Agent 快速接手。
- 检查规则或文档是否漂移时，优先使用 `agent-rules-drift-check` skill。
