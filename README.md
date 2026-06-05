# 多 Agent CLI 单源配置最佳实践

适用对象：Claude Code、Codex、Kimi Code、opencode，以及未来新增的 Agent CLI。

核心结论：用 `AGENTS.md` 做主配置，用各 Agent 自己识别的入口文件做“薄适配层”。不要把同一套规则复制成多份。

## 当前项目定位

本项目目录 `~/.agent-rules/` 是多 Agent 共享规则的长期维护仓库：

```text
~/.agent-rules/
  AGENTS.md              # 当前生效的跨 Agent 主配置
  CLAUDE.md              # 当前项目内的 Claude Code 薄适配层
  README.md              # 方案说明
  install-example.sh     # 安装示例
  templates/             # 项目级、适配层和 skill 模板
```

这里维护 agent 行为规则和模板；skills 的长期中心仓库仍然是 `skillsPanel`。

## 1. 推荐目录结构

全局规则放在一个中立目录；skills 交给 `skillsPanel` 管理：

```text
~/.agent-rules/
  AGENTS.md

~/.skills-panel/
  skills/
    <skill-name>/
      SKILL.md
      scripts/
      templates/
      references/
```

各 CLI 的全局入口只负责指向或导入它：

```text
~/.claude/CLAUDE.md             # Claude Code 入口
~/.codex/AGENTS.md              # Codex 入口
~/.kimi/AGENTS.md               # Kimi Code 入口
~/.config/opencode/AGENTS.md    # opencode 入口
```

项目内也统一用：

```text
AGENTS.md
CLAUDE.md
```

其中项目 `CLAUDE.md` 建议只写：

```md
@AGENTS.md
```

## 2. 分层模型

### 全局 `AGENTS.md`

只放跨所有项目都成立的规则：

- 中文沟通偏好
- 工具使用原则
- Git 安全红线
- 不硬编码密钥
- 验证和失败处理原则
- skill 使用原则

不要放具体项目命令、具体仓库路径、过长工具手册。

### 项目 `AGENTS.md`

放当前项目的 Agent 操作入口和风险边界：

- 指向 `Reference_myself/` 的阅读入口
- 默认只读区、禁止自动修改区、需确认修改区
- 项目专属结构化工具入口，比如 CodeGraph、GitNexus
- 项目特有验证例外
- AI 容易误判的路径、依赖和历史包袱

项目背景、PRD、技术设计、数据库设计、接口文档、开发计划、项目自述等事实性内容统一放在 `Reference_myself/`。项目 `AGENTS.md` 只引用路径和阅读顺序，不复制长内容。

项目 `AGENTS.md` 可以提交到仓库；`Reference_myself/` 默认是本地私有资料目录，不要求进入仓库。

### `SKILL.md`

你的 skill 使用 [zhangsubo/skillsPanel](https://github.com/zhangsubo/skillsPanel) 统一管理，因此 `~/.skills-panel/skills/` 是 skills 的中央仓库。

把“低频但复杂”的能力沉淀成 skill：

- 步骤超过 5 步
- 需要模板或脚本
- 需要引用资料
- 未来多个 agent 都会用

`AGENTS.md` 是常驻规则，`SKILL.md` 是按需能力。全局规则越短，Agent 越稳定。

skills 的安装、导入、导出、同步、健康检查都通过 skillsPanel 完成，不建议各 Agent CLI 自己维护一份独立 skill 目录。Agent 侧只消费 skillsPanel 同步过去的结果。

## 3. 从你现有 `CLAUDE.md` 的迁移建议

你现在的 `~/.claude/CLAUDE.md` 可以拆成三层：

| 现有内容 | 推荐去向 |
|---|---|
| 中文沟通、极简结构化 | 全局 `~/.agent-rules/AGENTS.md` |
| 工具优先级、不要盲读源码 | 全局 `AGENTS.md`，但写成通用原则 |
| Git 分支保护、push 拦截 | 全局 `AGENTS.md` |
| `Reference_myself/[auto]项目名称.md` | 项目事实源，项目 `AGENTS.md` 只引导读取，不复制内容 |
| 防御性编程、零硬编码、熔断机制 | 全局 `AGENTS.md` |
| CodeGraph 大段说明 | 项目 `AGENTS.md`，只在有 `.codegraph/` 或 MCP 的项目启用 |
| `@RTK.md` | Claude 专属适配层，或迁移成公共 rules 文件 |

重点：CodeGraph 不建议全局强制。不是每个项目都有 CodeGraph，放全局会导致其他 agent 在无该工具时产生无效动作。

## 4. 推荐安装方式

推荐使用交互式安装脚本：

```sh
./install-example.sh
```

脚本会提示选择本次要配置的 Agent，目前支持：

- Claude Code
- Codex
- Kimi Code
- opencode

注意：安装脚本仅支持 macOS 下各 Agent 的默认配置路径。如果你使用 Windows，或自定义过 `AGENTS.md` / `CLAUDE.md` 的存储位置，请手动配置，不要使用脚本自动覆盖。

手动配置时，先创建单源规则目录。这里只管理 agent instructions，不管理 skills：

```sh
mkdir -p ~/.agent-rules
cp AGENTS.md ~/.agent-rules/AGENTS.md
```

Codex、Kimi、opencode 可以用软链接：

```sh
mkdir -p ~/.codex ~/.kimi ~/.config/opencode
ln -sf ~/.agent-rules/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.kimi/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.config/opencode/AGENTS.md
```

Claude Code 保留 `CLAUDE.md` 入口：

```sh
mkdir -p ~/.claude
cat > ~/.claude/CLAUDE.md <<'EOF'
@/Users/zhangsubo/.agent-rules/AGENTS.md

## Claude Code Adapter

- Claude 专属规则写在这里。
EOF
```

如果你确认当前 Claude Code 环境支持 `~` 展开，也可以写：

```md
@~/.agent-rules/AGENTS.md
```

## 5. 新项目初始化模板

项目根目录：

```text
AGENTS.md
CLAUDE.md
Reference_myself/        # 本地私有项目知识库，可被 .gitignore 排除
```

`CLAUDE.md`：

```md
@AGENTS.md
```

`AGENTS.md` 只写 Agent 操作入口和边界，项目事实写入 `Reference_myself/`：

```text
Reference_myself/
  00. README.md                 # 文档清单和阅读路径
  01. PRD-YYYYMMDD-vX.Y.md
  02. 技术设计文档-YYYYMMDD-vX.Y.md
  03. 数据库设计文档-YYYYMMDD-vX.Y.md
  04. 接口文档-YYYYMMDD-vX.Y.md
  05. 开发计划-YYYYMMDD-vX.Y.md
  98. [auto]agent-rules-drift-review-YYYYMMDD.md
  99. [auto]项目自述-YYYYMMDD-vX.Y.md
  history_backup/               # 同编号旧版文档留档
```

同一个编号如果出现不同日期或版本的文档，根目录只保留最新版本，旧版本移动到 `Reference_myself/history_backup/` 留档。

如果是 monorepo，可以在子目录增加更具体的 `AGENTS.md`：

```text
apps/web/AGENTS.md
services/api/AGENTS.md
packages/ui/AGENTS.md
```

原则：越靠近工作目录的规则越具体。

## 6. 规则写作规范

- 每条规则必须可执行，不写“写高质量代码”这种空话。
- 全局规则尽量控制在 80 到 150 行。
- 不重复：全局写习惯，项目写入口和边界，`Reference_myself/` 写项目事实，skill 写流程。
- 不把 token、API key、私有 endpoint 写进项目共享规则。
- 对高风险操作依赖工具权限、hook、sandbox 做硬约束，文字规则只做第二层提醒。

## 7. 推荐演进路线

第一阶段：把现有 Claude 全局规则迁移成 `~/.agent-rules/AGENTS.md`。

第二阶段：各 CLI 全局入口都指向这份主配置。

第三阶段：给常用项目补项目级 `AGENTS.md`。

第四阶段：把长流程拆成 skills，比如：

- `agent-rules-drift-check`
- `code-review`
- `frontend-polish`
- `lark-workflow`
- `project-onboarding`
- `release-checklist`

这些 skill 应该通过 skillsPanel 安装到 `~/.skills-panel/skills/`，再由 skillsPanel 同步到 Claude Code、Codex、Kimi Code、opencode 等工具目录。

## 8. skillsPanel 集成约定

把 skillsPanel 当作 skill 的唯一管理面板：

- 中央仓库：`~/.skills-panel/skills/`
- 支持格式：`SKILL.md` 和 `skill.md`
- 支持安装来源：本地目录、ZIP、Git 仓库
- 支持同步方式：Symlink / Copy
- 支持目标工具：Claude Code、Codex、OpenCode、Cursor 等；Kimi Code 可按其实际 skill 目录作为后续目标补充
- 支持项目工作区：可扫描 `.claude/skills/`、`.cursor/skills/` 等项目内 skill 目录，并导入/导出到中央仓库

配置原则：

- `AGENTS.md` 不写长 skill 内容，只写“如何发现和使用 skill”。
- 新 skill 先进入 skillsPanel 中央仓库，再同步到目标 Agent CLI。
- 不手工在多个 Agent 的 skill 目录复制同一份 skill。
- 如果某个 Agent 暂时不支持 skill 目录，就在它的全局 `AGENTS.md` 里说明：需要 skill 时优先读取 `~/.skills-panel/skills/<skill-name>/SKILL.md`。

## 9. 官方依据

- Claude Code memory 文档说明 `CLAUDE.md` 的全局/项目层级、`@path` 导入语法，并建议团队可维护 `AGENTS.md` 且由 `CLAUDE.md` 导入。
- OpenAI Codex 文档说明 Codex 会读取全局 `~/.codex/AGENTS.md` 和项目内 `AGENTS.md`。
- Kimi Code 文档说明支持用户级 `~/.kimi/AGENTS.md` 和项目级 `AGENTS.md`。
- opencode 文档说明支持全局 `~/.config/opencode/AGENTS.md` 与项目级 `AGENTS.md`，并兼容从 Claude 迁移的规则文件。
