# dotfiles

> macOS setup for DevOps & Security work — reproducible, fast, opinionated.

![Platform](https://img.shields.io/badge/platform-macOS-black?logo=apple&logoColor=white)
![Shell](https://img.shields.io/badge/shell-zsh-informational?logo=gnubash&logoColor=white)
![Terminal](https://img.shields.io/badge/terminal-ghostty-purple)
![Prompt](https://img.shields.io/badge/prompt-starship-DD0B78?logo=starship&logoColor=white)
![Packages](https://img.shields.io/badge/packages-~109-blue)
![Last Sync](https://img.shields.io/badge/synced-May%202026-brightgreen)

---

## What's inside

| File | Description |
|------|-------------|
| `install.sh` | One-command bootstrap — Homebrew → packages → symlinks |
| `brewfile` | ~109 Homebrew packages organized into sections |
| `zshrc` | Zsh config — starship prompt, modern CLI tools, aliases, functions |
| `ghostty/config` | [Ghostty](https://ghostty.org) terminal configuration |
| `nvim/` | [LazyVim](https://lazyvim.org) neovim config — self-bootstrapping |
| `starship/starship.toml` | Custom [Starship](https://starship.rs) prompt config |
| `CLAUDE.md` | Claude Code project context |
| `AGENTS.md` | AI agent context (OpenCode, Codex CLI, etc.) |

### Shell highlights

- **Prompt** — [Starship](https://starship.rs)
- **Modern CLI** — `eza` · `bat` · `fd` · `ripgrep` · `dust` · `btop` · `procs`
- **Navigation** — [zoxide](https://github.com/ajeetdsouza/zoxide) (smarter `cd`)
- **Search** — [fzf](https://github.com/junegunn/fzf) with `fd` backend
- **Python** — [uv](https://github.com/astral-sh/uv) (version management + packages)
- **JS/TS** — [bun](https://bun.sh) (replaces npm/npx)
- **Env** — [direnv](https://direnv.net) for per-directory variables

---

## Setup

### Fresh Mac — one command

```bash
git clone https://github.com/RohiRIK/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` will:
1. Install Homebrew if missing
2. Run `brew bundle install` (~109 packages)
3. Symlink `zshrc`, `nvim/`, `starship.toml`, and Ghostty config
4. Back up any existing files as `.bak`
5. Print next steps

### After install

```bash
source ~/.zshrc          # reload shell
claude                   # authenticate Claude Code (opens browser)
```

---

## AI Tooling

All AI tools are installed via the Brewfile — no separate steps needed.

| Tool | What it does |
|------|-------------|
| `claude` / `claude-code@latest` | Claude Code CLI — AI coding agent |
| `chatgpt` | ChatGPT desktop app |
| `ollama` | Local LLMs — run models offline |
| `fabric-ai` | AI workflow automation framework |
| `opencode` | OpenCode CLI — AI coding agent |

### Claude Code

```bash
claude                              # first run opens browser auth
claude mcp add <name> <command>     # add an MCP server
brew upgrade claude-code@latest     # update (Homebrew won't auto-update)
```

### Ollama (local LLMs)

```bash
ollama pull llama3.2                # download a model
ollama run llama3.2                 # chat in terminal
```

---

## Keeping in sync

To regenerate `brewfile` from your current system:

```bash
brew bundle dump --force --file=~/dotfiles/brewfile
```

Then commit and push as usual.

---

## License

Personal config — use freely, no warranty.
