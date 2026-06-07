# Agent Rules

面向多 Agent CLI 的单源规则仓库。

这个仓库用于维护一份可复用的 Agent 行为规则，并通过轻量适配层同步给 Claude Code、Codex、Kimi Code、opencode 等工具。目标是避免在多个 Agent 配置目录里复制多份规则，减少漂移和维护成本。

## 特性

- 单源维护：以 `AGENTS.md` 作为跨 Agent 的主规则文件。
- 薄适配层：不同 Agent 只保留必要入口，例如 Claude Code 使用 `CLAUDE.md` 引用主规则。
- 项目模板：提供项目级 `AGENTS.md`、`CLAUDE.md` 和 Agent 项目文档结构。
- Skill 分离：常驻规则放在 `AGENTS.md`，复杂流程沉淀为 `SKILL.md`。
- 安全优先：内置 Git 安全、密钥保护、影响分析、验证回写等规则建议。

## 适用场景

- 你同时使用多个 Agent CLI，希望它们共享同一套行为规则。
- 你想把全局规则、项目规则、项目事实文档和 skills 分层管理。
- 你希望新项目可以快速初始化一套面向 Agent 的协作说明。
- 你想降低不同 Agent / 不同项目之间的规则漂移。

## 支持的 Agent

当前安装脚本支持 macOS 默认路径下的：

- Claude Code
- Codex
- Kimi Code
- opencode

其他 Agent 也可以手动接入，只要它支持读取 `AGENTS.md`、`CLAUDE.md` 或类似入口文件。

## 仓库结构

```text
.
├── AGENTS.md                         # 跨 Agent 主规则
├── CLAUDE.md                         # 当前仓库的 Claude Code 入口
├── install-example.sh                 # macOS 交互式安装示例
├── templates/
│   ├── adapters/
│   │   └── CLAUDE.md                  # Claude Code 全局适配层模板
│   ├── project/
│   │   ├── AGENTS.md                  # 项目级 Agent 规则模板
│   │   └── CLAUDE.md                  # 项目级 Claude Code 入口模板
│   └── skills/
│       ├── agent-rules-drift-check/   # 规则漂移检查 skill 模板
│       └── example-skill/             # skill 示例
├── LICENSE
└── README.md
```

## 快速开始

克隆仓库：

```sh
git clone https://github.com/<your-name>/agent-rules.git ~/.agent-rules
cd ~/.agent-rules
```

运行安装脚本：

```sh
./install-example.sh
```

脚本会提示选择要配置的 Agent，并在默认位置创建规则入口或软链接。

注意：安装脚本只面向 macOS 默认路径。如果你使用 Windows、Linux，或修改过各 Agent 的配置目录，请参考下面的手动配置方式。

## 手动配置

### Codex / Kimi Code / opencode

这些工具可以直接指向同一份 `AGENTS.md`：

```sh
mkdir -p ~/.codex ~/.kimi ~/.config/opencode

ln -sf ~/.agent-rules/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.kimi/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.config/opencode/AGENTS.md
```

### Claude Code

Claude Code 使用 `CLAUDE.md` 作为入口，可以创建一个薄适配层：

```sh
mkdir -p ~/.claude

cat > ~/.claude/CLAUDE.md <<'EOF'
@/Users/your-name/.agent-rules/AGENTS.md

## Claude Code Adapter

- Claude Code 专属规则写在这里。
EOF
```

如果你的 Claude Code 环境支持 `~` 展开，也可以写成：

```md
@~/.agent-rules/AGENTS.md
```

## 推荐分层

### 全局规则

全局规则写在：

```text
~/.agent-rules/AGENTS.md
```

适合放所有项目都成立的原则：

- 默认沟通语言和输出风格
- 工具使用优先级
- Git 安全边界
- 密钥和私有配置保护
- 修改后的验证要求
- skills 的使用原则

不建议放：

- 某个项目的启动命令
- 某个项目的接口细节
- 某个仓库专属路径
- 大段工具手册
- API key、token、私有 endpoint

### 项目规则

每个项目可以放一份项目级规则：

```text
your-project/
├── AGENTS.md
├── CLAUDE.md
└── Reference_myself/
```

项目级 `AGENTS.md` 只保留 Agent 执行任务前必须知道的入口和边界，例如：

- 文档阅读顺序
- 禁止自动修改的路径
- 需要确认的高风险操作
- 项目特有验证命令
- CodeGraph、GitNexus 等结构化工具入口

项目背景、PRD、技术设计、数据库设计、接口文档、开发计划和项目自述，建议统一放在 `Reference_myself/`。

### 项目文档

推荐结构：

```text
Reference_myself/
  00. README.md
  01. PRD-YYYYMMDD-vX.Y.md
  02. 技术设计文档-YYYYMMDD-vX.Y.md
  03. 数据库设计文档-YYYYMMDD-vX.Y.md
  04. 接口文档-YYYYMMDD-vX.Y.md
  05. 开发计划-YYYYMMDD-vX.Y.md
  98. [auto]agent-rules-drift-review-YYYYMMDD.md
  99. [auto]项目自述-YYYYMMDD-vX.Y.md
  history_backup/
```

其中：

- `00. README.md` 只做文档清单和用途说明。
- `99. [auto]项目自述-*.md` 用于帮助不同 Agent / 团队成员快速接手项目。
- 同编号旧版本移动到 `history_backup/`，根目录只保留最新版本。

## Skills 管理

本仓库不作为 skills 的中央仓库。推荐用独立的 skills 管理系统维护：

```text
~/.skills-panel/skills/
  <skill-name>/
    SKILL.md
    scripts/
    templates/
    references/
```

规则与 skill 的边界：

- `AGENTS.md`：常驻规则，短、稳定、全局适用。
- `SKILL.md`：按需流程，适合复杂、低频、可复用任务。

当一个流程超过 5 步，或需要脚本、模板、参考资料时，优先沉淀为 skill，而不是继续塞进 `AGENTS.md`。

## 设计原则

- 单源优先：同一条规则只维护一份。
- 分层清晰：全局写习惯，项目写边界，文档写事实，skill 写流程。
- 可执行：规则要能指导动作，不写空泛口号。
- 可迁移：尽量不绑定某个 Agent 的专有能力。
- 安全默认：不自动覆盖用户改动，不提交密钥，不默认执行高风险操作。
- 控制长度：全局规则保持简洁，避免 Agent 上下文被长期规则占满。

## 新项目初始化建议

复制项目模板：

```sh
cp templates/project/AGENTS.md /path/to/your-project/AGENTS.md
cp templates/project/CLAUDE.md /path/to/your-project/CLAUDE.md
```

然后在项目中创建文档目录：

```sh
mkdir -p /path/to/your-project/Reference_myself/history_backup
```

如果项目会公开到 GitHub，而 `Reference_myself/` 中包含个人笔记、业务细节或敏感信息，建议把它加入 `.gitignore`。

## 维护建议

- 修改全局规则后，检查各 Agent 入口是否仍指向同一份 `AGENTS.md`。
- 修改项目结构、接口、数据库或开发流程后，同步更新项目级文档。
- 定期检查各项目的 `AGENTS.md` 是否复制了过长内容，必要时迁回 `Reference_myself/` 或 skill。
- 对高风险规则优先使用权限、hook、sandbox 或 CI 做硬约束，文字规则只作为提醒。

## License

见 [LICENSE](LICENSE)。
