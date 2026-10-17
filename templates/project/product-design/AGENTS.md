# Product Design Agent Instructions

## Project Type

- 当前项目类型：产品设计。
- 产品任务按需读取 `~/.agent-rules/rules/project-types/product-manager.md`，并遵循本文件的项目边界。

## Project Knowledge

- 项目资料优先放在 `Reference_myself/`；正式产物优先放在产品交付目录。
- 需要项目事实时，先读 `Reference_myself/00. README.md` 或文档清单定位入口：需求任务读取需求和会议纪要，原型任务读取对应 PRD 与原型说明，评审任务读取待评审产物及验收标准，版本规划读取版本计划。无需通读全部资料。
- 不把敏感信息、私有客户资料、token、API key、密码或私有 endpoint 写入规则、公开文档或提交。

推荐目录：

```text
Reference_myself/
  00. README.md
  01. 需求材料-YYYYMMDD-vX.Y.md
  02. 用户研究-YYYYMMDD-vX.Y.md
  03. 竞品分析-YYYYMMDD-vX.Y.md
  04. 评审记录-YYYYMMDD-vX.Y.md
  99. [auto]项目自述-YYYYMMDD-vX.Y.md
  history_backup/
prd/
prototype/
flowcharts/
annex/
templates/
```

## Required Skill

- 产品规划与产物生成任务必须使用 `pm-workflow` skill。
- 执行时读取并遵循该 skill 的完整说明；本文件不复制 skill 流程。

## Product Workflow

- 先明确背景/痛点、业务目标、用户与场景、核心用户旅程、现有方案、业务规则、参考/竞品。
- PRD 必须区分事实、推断、假设和待确认事项。
- 原型必须覆盖关键页面、关键状态、异常状态和主路径交互。
- 原型变化后，同步更新 PRD 中对应的详细方案和验收标准。
- 流程图优先覆盖核心主线、异常分支、权限/空状态/断网等边界情况。

## Deliverables

- PRD：存放在 `prd/`。
- 原型：存放在 `prototype/`。
- 流程图：存放在 `flowcharts/`。
- 附件：原始材料、数据字典、参考资料放入 `annex/`。

## Protected Areas

- 默认只读目录：
- 禁止自动修改的文件：
- 需要用户确认后才能修改的文件：
- 涉及客户隐私、商业机密、发布时间、承诺交付范围、价格、法务、财务或生产系统的数据必须先确认。

## Verification Matrix

- 需求确认：用户明确表示方向、范围和基础逻辑正确。
- PRD 检查：背景、目标、用户旅程、功能清单、验收标准、异常边界完整。
- 原型检查：主路径、返回路径、空状态、错误状态、成功反馈、权限差异可见。
- 流程图检查：主线和异常分支可渲染，无 Mermaid 语法错误。
- 版本检查：新版产物不覆盖历史版本，相关文件路径保持一致。

## Documentation Writeback

- 需求、范围、原型、流程图或版本变化后，同步更新对应 PRD、原型和 `Reference_myself/00. README.md`。
- 如果不确定写入哪里，先写入 `Reference_myself/99. [auto]项目自述-*.md` 或待整理记录，避免关键信息只留在聊天中。

## Known Gotchas

- 容易遗漏的用户场景：
- 容易误判的业务规则：
- 容易遗漏的异常状态：
- 不能参考通用产品经验处理的项目特例：
