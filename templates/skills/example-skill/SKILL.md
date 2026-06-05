# Example Skill

## When To Use

当任务是可重复流程，并且步骤、模板、脚本或参考资料超过简单聊天说明时使用。

## Inputs

- 用户目标：
- 目标项目或文件：
- 约束条件：
- 期望输出：

## Outputs

- 完成后的代码、文档、配置或其他交付物。
- 简短验证结果。
- 剩余风险或后续建议。

## Workflow

1. 从上下文确认目标和约束。
2. 只读取完成任务所需的文件或参考资料。
3. 复用现有模板、脚本和项目约定。
4. 完成最小必要改动。
5. 运行匹配风险的验证。
6. 汇报变更、验证结果和残余风险。

## Directory Convention

```text
~/.skills-panel/skills/example-skill/
  SKILL.md
  scripts/
  templates/
  references/
```

通过 skillsPanel 将该 skill 同步到目标 Agent CLI。
