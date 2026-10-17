---
name: example-skill
description: 仅当用户明确要求参考或定制 skill 模板时使用；复制后替换为目标 skill 的具体触发条件。
---

# Example Skill

这是模板，不作为通用任务的兜底路由。实例化时替换 name、description 和下列占位项。

## Inputs

- 用户目标：
- 目标项目或文件：
- 约束条件：
- 期望输出：

## Outputs

- 完成后的代码、文档、配置或其他交付物。
- 验证结果及必要的剩余风险说明。

## Verification And Completion

按风险选择最小必要验证。完成定义：交付物可运行或可打开，输出已检查，可修复报错已修复并复测通过；外部阻塞须明确说明，不能声称验证通过。

需要脚本、模板、参考资料时，分别添加 scripts/、templates/、references/，并在入口标明读取条件。长期维护位置为 `~/.skills-panel/skills/`，通过 skillsPanel 同步到目标 Agent CLI。
