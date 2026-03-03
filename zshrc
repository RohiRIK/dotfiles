## =============================================================================
# macOS Zsh Configuration
# DevOps & Security Professional Setup
# =============================================================================

# Performance: Skip compinit check for faster startups (run manually: compinit)
# Uncomment for faster startup (but run 'compaudit' periodically)
# skip_global_compinit=1

# =============================================================================
# OH MY ZSH
# =============================================================================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (using starship instead, see bottom of file)
ZSH_THEME=""

# Performance optimizations
DISABLE_AUTO_UPDATE="true"          # Manual updates: omz update
DISABLE_MAGIC_FUNCTIONS="true"      # Faster URL pasting
COMPLETION_WAITING_DOTS="true"      # Show dots while waiting for completion
HIST_STAMPS="yyyy-mm-dd"            # History timestamp format

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY             # Save timestamp and duration
setopt HIST_IGNORE_ALL_DUPS         # Remove older duplicates
setopt HIST_FIND_NO_DUPS            # Don't show duplicates in search
setopt HIST_REDUCE_BLANKS           # Remove extra blanks
setopt SHARE_HISTORY                # Share history across sessions
setopt INC_APPEND_HISTORY           # Write immediately, not on exit

# =============================================================================
# PLUGINS
# =============================================================================

plugins=(
    # Version Control
    git                             # Git aliases and functions
    gh                              # GitHub CLI completion
    
    # DevOps & Infrastructure
    docker                          # Docker completion and aliases
    docker-compose                  # Docker Compose completion
    kubectl                         # Kubernetes completion and aliases
    helm                            # Helm completion
    
    # Development
    node                            # Node.js aliases
    npm                             # NPM completion
    pip                             # Python pip completion
    python                          # Python aliases
    bun 

    # Productivity
    sudo                            # Double ESC to add sudo
    copypath                        # Copy current path: copypath
    copyfile                        # Copy file content: copyfile <file>
    web-search                      # Search web: google <query>
    jsontools                       # JSON formatting: pp_json
    
    # Oh My Zsh Custom Plugins (installed separately)
    zsh-autosuggestions            # Command suggestions
    zsh-syntax-highlighting        # Syntax highlighting (load last)
)

# Source Oh My Zsh
# source $ZSH/oh-my-zsh.sh

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Homebrew (Apple Silicon)
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# PATH additions
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# Development paths
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"          # Rust

# Python (pyenv PATH — init and PYENV_ROOT set further below)
export PATH="$HOME/.pyenv/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# =============================================================================
# MODERN CLI TOOLS
# =============================================================================

# fzf - Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Starship prompt - Fast, customizable prompt
eval "$(starship init zsh)"

# direnv - Per-directory environment variables
eval "$(direnv hook zsh)"

# pyenv - Python version management (no-rehash = faster startup)
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
    eval "$(pyenv init - --no-rehash)"
fi

# =============================================================================
# ALIASES - General
# =============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Modern replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias cat='bat --style=auto'
alias grep='rg'
alias find='fd'
alias du='dust'
alias ps='procs'
alias top='btop'

# Bun (replaces npm/npx)
alias npm='bun'
alias npx='bunx'
alias nr='bun run'
alias ni='bun install'
alias na='bun add'
alias nrd='bun add -d'
alias nrm='bun remove'

# AI Tools
alias fabric='fabric-ai'            # Fabric AI framework by Daniel Miessler

# File operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias reload='source ~/.zshrc'
alias brewfile='$EDITOR ~/dotfiles/Brewfile'

# System
alias cleanup='brew cleanup -s && brew autoremove'
alias update='brew update && brew upgrade && mas upgrade'
alias myip='curl ifconfig.me'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'

# =============================================================================
# ALIASES - Development
# =============================================================================

# HTTP testing
alias http='httpie'
alias https='http --verify=no'

# JSON formatting
alias json='python3 -m json.tool'

alias homelab="ssh rohi@192.168.2.7"

# =============================================================================
# FUNCTIONS
# =============================================================================

# Create and cd into directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find process by name
fp() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Kill process by name
fkill() {
    local pid
    pid=$(ps aux | grep -v grep | grep -i "$1" | awk '{print $2}')
    if [ -z "$pid" ]; then
        echo "No process found"
    else
        kill -9 "$pid"
        echo "Killed process $pid"
    fi
}

# Git clone and cd
gcl() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Docker cleanup
dclean() {
    docker system prune -af --volumes
    docker volume prune -f
}

# Kubernetes context switch
kcontext() {
    kubectl config use-context "$1"
}

# Measure zsh startup time
timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# Backup Brewfile
brewbackup() {
    cd ~/dotfiles && ./backup.sh
}

# =============================================================================
# SECURITY & NETWORKING
# =============================================================================

# Quick nmap scan
portscan() {
    nmap -sV -T4 "$1"
}

# Check SSL certificate
sslcheck() {
    echo | openssl s_client -servername "$1" -connect "$1":443 2>/dev/null | openssl x509 -noout -dates
}

# =============================================================================
# COMPLETION SETTINGS
# =============================================================================

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Completion menu
zstyle ':completion:*' menu select

# Directory colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# =============================================================================
# NVM (Node Version Manager) — lazy loaded for fast startup
# nvm/node/npm/npx trigger the real load on first use
# =============================================================================
export NVM_DIR="$HOME/.nvm"
_nvm_load() {
    unset -f nvm node _nvm_load
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { _nvm_load; nvm  "$@"; }
node() { _nvm_load; node "$@"; }

# =============================================================================
# CUSTOM CONFIGS
# =============================================================================

# Load custom configurations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load work-specific configs
[ -f ~/.zshrc.work ] && source ~/.zshrc.work

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Fix Shift+Enter in Ghostty
bindkey "^[[13;2u" accept-line
bindkey "^[[27;2;13~" accept-line

# Claude Code 

# Daily development
alias claude-dev='claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'

# PR review mode
alias claude-review='claude --system-prompt "$(cat ~/.claude/contexts/review.md)"'

# Research/exploration mode
alias claude-research='claude --system-prompt "$(cat ~/.claude/contexts/research.md)"'

# Added by Antigravity
export PATH="/Users/rohirikman/.antigravity/antigravity/bin:$PATH"

# opencode
export PATH=/Users/rohirikman/.opencode/bin:$PATH
export PATH="$HOME/.bun/bin:$PATH"
# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# =============================================================================
# ZOXIDE INITIALIZATION (MUST REMAIN AT THE END)
# =============================================================================
export _ZO_DOCTOR=0
eval "$(zoxide init zsh --cmd cd)"
