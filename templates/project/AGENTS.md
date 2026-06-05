# Project Agent Instructions

## Project Knowledge

- 项目介绍、PRD、技术设计、数据库设计、接口文档、开发计划和 Agent 项目自述统一放在 `Reference_myself/`。
- 接手任务时，先阅读 `Reference_myself/` 中的 README 或文档清单，再按任务类型读取相关文档。
- `Reference_myself/` 默认是本地私有资料目录，不要求进入仓库；不要把其中的敏感信息复制到公开文件。
- 本文件不重复维护项目背景、完整架构、API 细节、数据库设计和开发计划；这里只保留 Agent 执行任务时必须先看到的入口和边界。

文档结构严格遵循：

```text
Reference_myself/
  00. README.md                 # 文档清单和阅读路径
  01. PRD-YYYYMMDD-vX.Y.md      # 产品需求
  02. 技术设计文档-YYYYMMDD-vX.Y.md
  03. 数据库设计文档-YYYYMMDD-vX.Y.md
  04. 接口文档-YYYYMMDD-vX.Y.md
  05. 开发计划-YYYYMMDD-vX.Y.md
  98. [auto]agent-rules-drift-review-YYYYMMDD.md
  99. [auto]项目自述-YYYYMMDD-vX.Y.md
  history_backup/               # 同编号旧版文档留档
  others/                       # 旧版、归档或参考材料
```

## Operational Overrides

仅填写 `Reference_myself/` 或项目公开文档中没有覆盖、但 Agent 每次执行都必须知道的短规则。能放进项目文档的长说明不要写在这里。

## Protected Areas

- 默认只读目录：
- 禁止自动修改的文件：
- 需要用户确认后才能修改的文件：
- 涉及生产数据、认证、支付、权限、删除、迁移、部署的操作必须先做影响分析并等待确认。

## Coding Rules

- 遵循 `Reference_myself/` 和现有代码中记录的代码风格、目录边界和架构约定。
- 公共 API、数据结构、数据库 schema 改动前先评估影响范围，并回看对应设计文档。
- 新增用户可见行为需要覆盖测试，或说明无法测试的原因。

## Risk Notes

- 不提交 `.env`、密钥、token、私有证书。
- 修改认证、支付、权限、数据删除、迁移脚本时先做影响分析。

## Project Tools

- 如果本项目有 CodeGraph、GitNexus、language server 或类似索引，结构分析优先使用这些工具。
- 文本搜索只用于查找字面内容、日志、注释和配置键。

## Verification Matrix

- 默认检查命令见 `Reference_myself/00. README.md` 或项目公开 README。
- 只在这里记录项目特有的验证例外：

## Documentation Writeback

- 功能性修改、架构调整、接口变化、数据库变化后，同步更新 `Reference_myself/` 中对应文档。
- `Reference_myself/` 中如果出现同一个编号但日期或版本不一致的文档，只保留最新文件在根目录，将旧文件移动到 `Reference_myself/history_backup/` 留档。
- 若项目已有公开文档约定，公开文档和 `Reference_myself/` 的边界要保持清楚：公开文档面向团队/用户，`Reference_myself/` 面向个人和 Agent 快速接手。
- 如果不确定该更新哪份文档，先写入 `Reference_myself/99. [auto]项目自述-*.md` 或待整理记录，避免关键信息只留在聊天中。

## Known Gotchas

- AI 容易误判的路径：
- AI 容易误用的 API / 依赖：
- 历史包袱或临时兼容逻辑：
- 不能按通用经验处理的项目特例：
