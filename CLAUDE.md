# dotfiles — Claude Code context

## What this repo is

Personal macOS dotfiles. Every file here gets symlinked into `~/` by `install.sh`. The goal is a reproducible, one-command Mac setup.

## Structure

```
dotfiles/
├── brewfile              # All Homebrew packages — source of truth
├── zshrc                 # Zsh config (symlinked to ~/.zshrc)
├── ghostty/config        # Ghostty terminal config
├── nvim/                 # LazyVim config (symlinked to ~/.config/nvim)
├── starship/
│   └── starship.toml     # Starship prompt (symlinked to ~/.config/starship.toml)
├── install.sh            # Bootstrap script — idempotent, safe to re-run
├── CLAUDE.md             # This file
└── AGENTS.md             # Same content, agent-neutral language
```

## Key conventions

- **Flat structure** — config files live at the repo root or in one named subdirectory. No deep nesting.
- **Symlinks, not copies** — `install.sh` creates symlinks so edits in the repo apply immediately.
- **`bun` over npm/npx** — use `bun` and `bunx` for all JS/TS operations.
- **`uv` over pip** — use `uv pip`, `uv python`, `uvx` for all Python operations.
- **`jq` over python3** — use `jq` for all JSON parsing in shell.

## Brewfile

The Brewfile is the single source of truth for installed packages.

- **Regenerate from live system:** `brew bundle dump --force --file=brewfile`
- **Install on fresh Mac:** `brew bundle install --no-upgrade --file=brewfile`
- Organized into sections: Taps · Core CLI · Dev Tools · Security & DevOps · AI Tools · Productivity · Apps · Work · Fonts
- Removed packages are documented in the `# === Removed ===` block at the bottom — check there before re-adding anything.

## install.sh

- Idempotent — safe to run multiple times on the same machine or a new one.
- Backs up existing files to `.bak` before symlinking.
- Skips symlinks that are already correct.
- Run it: `./install.sh`

## Claude Code

- Installed via `cask "claude-code@latest"` in the Brewfile.
- **Homebrew does NOT auto-update Claude Code** — run `brew upgrade claude-code@latest` to update.
- First-run auth: type `claude` in the terminal — browser opens automatically.
- Add MCP servers: `claude mcp add <name> <command>`

## Neovim

- Using **LazyVim** distribution. Config lives in `nvim/`.
- lazy.nvim self-bootstraps on first `nvim` launch — no manual setup needed.
- Plugin changes go through LazyVim conventions (`nvim/lua/plugins/`).
- Do not modify `nvim/lazy-lock.json` manually — it's managed by `:Lazy sync`.
