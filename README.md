# dotfiles

> macOS setup for DevOps & Security work — reproducible, fast, opinionated.

![Platform](https://img.shields.io/badge/platform-macOS-black?logo=apple&logoColor=white)
![Shell](https://img.shields.io/badge/shell-zsh-informational?logo=gnubash&logoColor=white)
![Terminal](https://img.shields.io/badge/terminal-ghostty-purple)
![Prompt](https://img.shields.io/badge/prompt-starship-DD0B78?logo=starship&logoColor=white)
![Last Sync](https://img.shields.io/badge/synced-Mar%202026-brightgreen)

---

## What's inside

| File | Description |
|------|-------------|
| `zshrc` | Zsh config — starship prompt, modern CLI tools, aliases, functions |
| `brewfile` | 133 Homebrew packages — apps, CLI tools, fonts |
| `ghostty/config` | [Ghostty](https://ghostty.org) terminal configuration |

### Shell highlights

- **Prompt** — [Starship](https://starship.rs)
- **Modern CLI** — `eza` · `bat` · `fd` · `ripgrep` · `dust` · `btop` · `procs`
- **Navigation** — [zoxide](https://github.com/ajeetdsouza/zoxide) (replaces `cd`)
- **Search** — [fzf](https://github.com/junegunn/fzf) with `fd` backend
- **Python** — [pyenv](https://github.com/pyenv/pyenv) (lazy, no-rehash)
- **JS/TS** — [bun](https://bun.sh) (replaces npm/npx)
- **Env** — [direnv](https://direnv.net) for per-directory variables

---

## Setup

### 1. Clone

```bash
git clone https://github.com/RohiRIK/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Install packages

```bash
brew bundle install
```

### 3. Link zshrc

```bash
# Back up existing config if needed
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak

ln -s ~/dotfiles/zshrc ~/.zshrc
source ~/.zshrc
```

### 4. Link Ghostty config

```bash
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
ln -s ~/dotfiles/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
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
