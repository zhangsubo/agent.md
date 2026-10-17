# Project Agent Instructions

## Project Type

- 当前项目类型：软件开发 / 产品设计 / 自媒体工作（保留一个或改成更具体的类型）。
- 先按项目类型读取全局规则中的对应模块，再读取本文件的项目边界。
- 如果本项目跨多个类型，写清主类型和辅助类型；执行任务时以用户最新目标为准。

## Project Knowledge

- 项目介绍、PRD、技术设计、数据库设计、接口文档、开发计划和 Agent 项目自述统一放在 `Reference_myself/`。
- 需要项目事实时，先读 `Reference_myself/00. README.md` 或文档清单定位入口；实现/调试读取技术文档，需求读取 PRD，接口变更读取接口文档，数据库变更读取数据库文档，规则漂移检查读取 `agent-rules-drift-check` skill。只读取与当前任务相关的资料。
- `Reference_myself/` 默认是本地私有资料目录，不要求进入仓库；不要把其中的敏感信息复制到公开文件。
- 本文件不重复维护项目背景、完整架构、API 细节、数据库设计和开发计划；这里只保留 Agent 执行任务时必须先看到的入口和边界。

文档结构示例（按需采用，不要求创建所有文件）：

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

## Product Design Workflow

当当前项目类型是“产品设计”时：

- 产品规划与产物生成必须使用 `pm-workflow` skill。
- 执行时读取并遵循该 skill 的完整说明；本文件不复制 skill 流程。

## Protected Areas

- 默认只读目录：
- 禁止自动修改的文件：
- 需要用户确认后才能修改的文件：
- 高危操作按 `~/.agent-rules/rules/git-safety.md` 判断授权范围；已有明确授权不重复确认。

## Software Development Rules

当当前项目类型是“软件开发”时：

- 遵循 `Reference_myself/` 和现有代码中记录的代码风格、目录边界和架构约定。
- 公共 API、数据结构、数据库 schema 改动前先评估影响范围，并回看对应设计文档。

## Risk Notes

- 不提交 `.env`、密钥、token、私有证书。
- 修改认证、支付、权限、数据删除、迁移脚本时先做影响分析。

## Project Tools

- 如果本项目有 CodeGraph、GitNexus、language server 或类似索引，结构分析优先使用这些工具。
- 文本搜索只用于查找字面内容、日志、注释和配置键。

## Verification Matrix

- 验证与本地隔离检查的自动执行遵循 `~/.agent-rules/rules/project-types/programming.md` 的 Verification（软件开发任务适用）。

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
