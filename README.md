# Personal development environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

Configuration for my editor, terminal, and AI-assisted development workflow.

## What's Inside

| Package | Description | Target |
|---------|-------------|--------|
| `nvim` | Neovim configuration (plugins, keybindings, colorschemes) | `~/.config/nvim/` |
| `tmux` | tmux terminal multiplexer config | `~/.tmux.conf` |
| `claude` | Claude Code development guides - global rules + language-specific | `~/.claude/` |

## Claude Development Guides

The `claude` package provides a layered development methodology for AI-assisted coding:

- **Global rules** (`CLAUDE.md`) - TDD workflow, quality gates, clean code standards, checklists. Applied to every project.
- **Language-specific guides** - Rust idioms, error handling, testing patterns. More languages coming.

```
claude/.claude/
├── CLAUDE.md          ← Universal rules (TDD, quality gates, clean code)
├── rust/              ← Rust-specific (ownership, clippy, thiserror, etc.)
└── java/              ← Coming soon
```

## Setup

```bash
git clone git@github.com:sim-hash/.dotfiles.git
cd .dotfiles
stow -t ~ nvim tmux claude
```

## Uninstall

```bash
stow -t ~ -D <package>    # e.g. stow -t ~ -D nvim
```
