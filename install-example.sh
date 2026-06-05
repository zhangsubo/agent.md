#!/usr/bin/env sh
set -eu

ROOT="$HOME/.agent-rules"

notice() {
  printf '%s\n' "$1"
}

ask_yes_no() {
  prompt="$1"
  default="${2:-n}"

  if [ "$default" = "y" ]; then
    suffix="[Y/n]"
  else
    suffix="[y/N]"
  fi

  while :; do
    printf '%s %s ' "$prompt" "$suffix"
    IFS= read -r answer || answer=""
    answer="${answer:-$default}"
    case "$answer" in
      y|Y|yes|YES) return 0 ;;
      n|N|no|NO) return 1 ;;
      *) notice "请输入 y 或 n。" ;;
    esac
  done
}

install_symlink() {
  target="$1"
  link="$2"
  name="$3"

  mkdir -p "$(dirname "$link")"

  if [ -e "$link" ] || [ -L "$link" ]; then
    if ! ask_yes_no "${name} 的入口文件已存在：${link}。是否替换为指向 ${target} 的软链接？" "n"; then
      notice "跳过 ${name}。"
      return 0
    fi
    rm -f "$link"
  fi

  ln -sf "$target" "$link"
  notice "已配置 ${name}：${link} -> ${target}"
}

install_claude() {
  target="$HOME/.claude/CLAUDE.md"
  name="Claude Code"

  mkdir -p "$HOME/.claude"

  if [ -e "$target" ] || [ -L "$target" ]; then
    if ! ask_yes_no "${name} 的入口文件已存在：${target}。是否覆盖为默认 Claude Code adapter？" "n"; then
      notice "跳过 ${name}。"
      return 0
    fi
  fi

  sed "s#{{AGENT_RULES_DIR}}#$ROOT#g" "templates/adapters/CLAUDE.md" > "$target"
  notice "已配置 ${name}：${target}"
}

notice "多 Agent 规则安装脚本"
notice ""
notice "提示：本安装脚本仅支持 macOS 下各 Agent 的默认配置路径。"
notice "如果你使用 Windows，或自定义过 AGENTS.md / CLAUDE.md 的存储位置，请不要使用本脚本自动安装，请按 README 手动配置。"
notice ""

if [ "$(uname -s)" != "Darwin" ]; then
  notice "当前系统不是 macOS，已停止安装。"
  exit 1
fi

if ! ask_yes_no "确认继续在 macOS 默认路径下安装？" "n"; then
  notice "已取消安装。"
  exit 0
fi

mkdir -p "$ROOT"
source_agents="$(pwd)/AGENTS.md"
target_agents="$ROOT/AGENTS.md"
if [ "$source_agents" != "$target_agents" ]; then
  cp "AGENTS.md" "$target_agents"
  notice "已安装主规则：$target_agents"
else
  notice "主规则已位于目标路径：$target_agents"
fi

notice ""
notice "请选择本次要配置的 Agent："

if ask_yes_no "是否配置 Claude Code？" "n"; then
  install_claude
fi

if ask_yes_no "是否配置 Codex？" "n"; then
  install_symlink "$ROOT/AGENTS.md" "$HOME/.codex/AGENTS.md" "Codex"
fi

if ask_yes_no "是否配置 Kimi Code？" "n"; then
  install_symlink "$ROOT/AGENTS.md" "$HOME/.kimi/AGENTS.md" "Kimi Code"
fi

if ask_yes_no "是否配置 opencode？" "n"; then
  install_symlink "$ROOT/AGENTS.md" "$HOME/.config/opencode/AGENTS.md" "opencode"
fi

notice ""
notice "安装流程结束。"
notice "Agent rules: $ROOT"
notice "Skills 仍由 skillsPanel 管理：$HOME/.skills-panel/skills"
