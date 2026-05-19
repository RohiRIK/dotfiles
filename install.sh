#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()    { echo -e "${BLUE}→${RESET} $1"; }
success() { echo -e "${GREEN}✓${RESET} $1"; }
warn()    { echo -e "${YELLOW}!${RESET} $1"; }
header()  { echo -e "\n${BOLD}$1${RESET}"; }

header "Dotfiles installer"
info "Source: $DOTFILES"

# =============================================================================
# 1. Homebrew
# =============================================================================
header "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon: add brew to PATH for this session
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew installed"
else
  success "Homebrew already installed ($(brew --version | head -1))"
fi

# =============================================================================
# 2. Brew bundle
# =============================================================================
header "Installing packages"
info "Running brew bundle install --no-upgrade..."
brew bundle install --no-upgrade --file="$DOTFILES/brewfile"
success "Packages installed"

# =============================================================================
# 3. Symlinks
# =============================================================================
header "Creating symlinks"

# Usage: make_link <source_in_dotfiles> <target_in_home>
make_link() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  # Ensure parent directory exists
  mkdir -p "$dst_dir"

  # Already a correct symlink — skip
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    success "Already linked: $dst"
    return
  fi

  # Existing file/dir — back it up
  if [[ -e "$dst" || -L "$dst" ]]; then
    warn "Backing up existing $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -s "$src" "$dst"
  success "Linked: $dst → $src"
}

make_link "$DOTFILES/zshrc"                    "$HOME/.zshrc"
make_link "$DOTFILES/nvim"                     "$HOME/.config/nvim"
make_link "$DOTFILES/starship/starship.toml"   "$HOME/.config/starship.toml"
make_link "$DOTFILES/ghostty/config"           "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# =============================================================================
# 4. Done
# =============================================================================
header "Done"
echo ""
echo -e "  ${GREEN}Your dotfiles are installed.${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo -e "  1. Reload your shell:    ${BLUE}source ~/.zshrc${RESET}"
echo -e "  2. Authenticate Claude:  ${BLUE}claude${RESET}  (opens browser on first run)"
echo -e "  3. Add MCP servers:      ${BLUE}claude mcp add <name> <command>${RESET}"
echo -e "  4. Local LLMs (Ollama):  ${BLUE}ollama pull llama3.2${RESET}"
echo ""
