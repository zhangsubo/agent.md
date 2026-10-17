# Agent Rules

面向多 Agent CLI 的单源规则仓库。

这个仓库用于维护一份可复用的 Agent 行为规则，并通过轻量适配层同步给 Claude Code、Codex、Kimi Code、Mimo Code、opencode 等工具。目标是避免在多个 Agent 配置目录里复制多份规则，减少漂移和维护成本。

## 特性

- 单源维护：以 `AGENTS.md` 作为跨 Agent 的主规则文件。
- 渐进式披露：`AGENTS.md` 只做入口和路由，详细规则按任务读取 `rules/`。
- 项目类型分流：软件开发、产品设计、自媒体工作等项目读取不同项目类型规则。
- 初始化引导：目录缺少项目级 Agent 入口时，从现有资料推断项目类型和默认值，只询问阻塞初始化的缺失信息，并验证入口与引用。
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
- Mimo Code
- opencode

其他 Agent 也可以手动接入，只要它支持读取 `AGENTS.md`、`CLAUDE.md` 或类似入口文件。

## 仓库结构

```text
.
├── AGENTS.md                         # 跨 Agent 主规则
├── CLAUDE.md                         # 当前仓库的 Claude Code 入口
├── install-example.sh                 # macOS 交互式安装示例
├── rules/                             # 按需加载的模块化规则
│   ├── core.md
│   ├── git-safety.md
│   ├── code-intelligence.md
│   ├── project-init.md
│   ├── project-docs.md
│   ├── mimo-image-bridge.md
│   └── project-types/
│       ├── programming.md
│       ├── product-manager.md
│       └── content-creator.md
├── templates/
│   ├── adapters/
│   │   └── CLAUDE.md                  # Claude Code 全局适配层模板
│   ├── project/
│   │   ├── AGENTS.md                  # 项目级 Agent 规则模板
│   │   ├── CLAUDE.md                  # 项目级 Claude Code 入口模板
│   │   └── product-design/
│   │       └── AGENTS.md              # 产品设计项目专用模板
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

## 升级和同步

如果你已经安装过旧版本，升级到模块化规则后需要确保 `rules/` 目录也存在于 `~/.agent-rules/`。最简单的方式是在仓库目录重新运行安装脚本：

```sh
cd ~/.agent-rules
./install-example.sh
```

脚本会先同步 `AGENTS.md` 和 `rules/`，再询问是否配置各 Agent。对于已经配置好的 Agent，如果提示入口文件已存在，可以选择 `n` 跳过；这不会影响主规则和模块规则的同步。

如果你的真实规则目录就是当前仓库 `~/.agent-rules`，通常不需要重新安装，因为 `rules/` 已经在仓库内。需要重新运行脚本的主要场景是：你从其他目录安装、想刷新默认路径下的规则副本，或想让 Mimo Code 等新 Agent 入口进入脚本管理。

## 手动配置

### Codex / Kimi Code / Mimo Code / opencode

这些工具可以直接指向同一份 `AGENTS.md`：

```sh
mkdir -p ~/.codex ~/.kimi ~/.config/mimocode ~/.config/opencode

ln -sf ~/.agent-rules/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.kimi/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.config/mimocode/AGENTS.md
ln -sf ~/.agent-rules/AGENTS.md ~/.config/opencode/AGENTS.md
```

手动配置时也要保留 `~/.agent-rules/rules/`。入口和模块统一使用 `~/.agent-rules/...` 引用，Agent 应先将 `~` 展开为用户主目录，再向文件工具传入绝对路径；不能从入口软链接所在目录解析 `rules/`。例如 Mimo Code 应读取 `~/.agent-rules/rules/project-docs.md`，而不是 `~/.config/mimocode/rules/project-docs.md`。无需在每个 Agent 配置目录增加 `rules` 软链接。

仅修改中心规则时，已有软链接无需重建；已运行的会话可能保留旧规则，请新建会话或显式重新读取入口。若将本仓库的 `CLAUDE.md` 软链接为全局入口，其主规则引用也指向 `~/.agent-rules/AGENTS.md`；项目内的 `CLAUDE.md` 仍引用项目自己的 `AGENTS.md`。

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

全局入口写在：

```text
~/.agent-rules/AGENTS.md
```

详细规则按模块放在：

```text
~/.agent-rules/rules/
```

`AGENTS.md` 只保留所有任务都要立即知道的短规则和模块索引。详细规则按任务读取：

| 项目类型 | 读取场景 |
|---|---|
| `~/.agent-rules/rules/project-types/programming.md` | 软件开发：开发、调试、重构、测试、发布 |
| `~/.agent-rules/rules/project-types/product-manager.md` | 产品设计：需求收集、PRD、用户故事、原型说明 |
| `~/.agent-rules/rules/project-types/content-creator.md` | 自媒体工作：公众号写作、小红书图文、选题、内容日历 |

| 模块 | 读取场景 |
|---|---|
| `~/.agent-rules/rules/core.md` | 需要完整沟通、任务判断、单一事实源原则 |
| `~/.agent-rules/rules/project-init.md` | 目录缺少项目级 Agent 入口，或用户要求初始化/补全项目初始化 |
| `~/.agent-rules/rules/git-safety.md` | 修改文件、提交、推送、处理用户已有改动 |
| `~/.agent-rules/rules/code-intelligence.md` | 代码理解、影响分析、重构、代码审查 |
| `~/.agent-rules/rules/project-docs.md` | `Reference_myself/`、文档回写、版本归档 |
| `~/.agent-rules/rules/mimo-image-bridge.md` | Mimo Pro 模型处理图片/截图/视觉理解 |

不建议放：

- 某个项目的启动命令
- 某个项目的接口细节
- 某个仓库专属路径
- 大段工具手册
- API key、token、私有 endpoint

安装或同步时，`AGENTS.md` 和 `rules/` 必须一起保留，否则模块引用会失效。

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

需要脚本、模板、参考资料或重复执行的复杂流程，优先沉淀为 skill，而不是继续塞进 `AGENTS.md`。

Skill 模板以 `SKILL.md` 作为路由入口，详细审查策略、报告格式和提示词放在 `references/`，Hook 仅在用户要求时读取 `scripts/`。产品规划与产物生成统一引用 `pm-workflow`。

`.baoyu-skills/baoyu-xhs-images/EXTEND.md` 是外部 `baoyu-xhs-images` skill 的项目配置，不是本仓库可调用 skill，不纳入 skill 路由。

私有 worktree 资料保护由 `orca-worktree-private-data` skill 维护，事实源位于 `~/.skills-panel/skills/orca-worktree-private-data/`；全局技能目录仅保存软链接。它提供外部持久目录接入、归档校验脚本及 Orca hook 配置说明。删除前保护规则见 `rules/git-safety.md`。安装 skill 不会自动为已有业务仓库配置 hook；首次接入须在目标仓库验证。

## 设计原则

- 单源优先：同一条规则只维护一份。
- 分层清晰：全局写习惯，项目写边界，文档写事实，skill 写流程。
- 可执行：规则要能指导动作，不写空泛口号。
- 可迁移：尽量不绑定某个 Agent 的专有能力。
- 安全默认：不自动覆盖用户改动，不提交密钥，不默认执行高风险操作。
- 控制长度：全局规则保持简洁，避免 Agent 上下文被长期规则占满。

## 新项目初始化建议

Agent 执行项目初始化时，按 `rules/project-init.md` 检查 Orca 归属；Orca 项目必须自动使用 `orca-worktree-private-data` skill 完成私有资料备份、创建和归档 hooks 配置及验证。已接入项目只补缺项，受阻时明确报告。此入口由 Agent 初始化流程触发；仅在 Orca 界面添加项目或手动复制模板不会自动执行。

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
