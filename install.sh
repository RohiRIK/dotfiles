#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Helper function for logging
info() {
    echo "INFO: $1"
}

# --- Step 1: Check and install Homebrew ---
if ! command -v brew &> /dev/null; then
    info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        info "Adding Homebrew to your PATH in .zprofile..."
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    info "Homebrew is already installed."
fi

# --- Step 2: Run brew bundle ---
info "Installing packages from Brewfile..."
# Change to the script's directory to find the Brewfile
cd "$(dirname "$0")" || exit
brew bundle install

# --- Step 3: Back up and link zshrc ---
ZSHRC_PATH="$HOME/.zshrc"
DOTFILES_ZSHRC_PATH="$(pwd)/zshrc"

if [ -L "$ZSHRC_PATH" ] && [ "$(readlink "$ZSHRC_PATH")" = "$DOTFILES_ZSHRC_PATH" ]; then
    info ".zshrc is already linked to this repository."
else
    if [ -e "$ZSHRC_PATH" ]; then
        info "Backing up existing .zshrc to .zshrc.bak..."
        mv "$ZSHRC_PATH" "$ZSHRC_PATH.bak"
    fi
    info "Creating symbolic link for .zshrc..."
    ln -s "$DOTFILES_ZSHRC_PATH" "$ZSHRC_PATH"
fi

# --- Step 4: Set Zsh as default shell ---
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
    info "Zsh is not the default shell."
    # Check if zsh is installed by brew
    if command -v /opt/homebrew/bin/zsh &> /dev/null; then
        ZSH_PATH="/opt/homebrew/bin/zsh"
    else
        ZSH_PATH="/bin/zsh"
    fi

    if ! grep -q "$ZSH_PATH" /etc/shells; then
        info "Adding Homebrew Zsh to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    
    info "Changing default shell to Zsh. You may be prompted for your password."
    chsh -s "$ZSH_PATH"
else
    info "Zsh is already the default shell."
fi

info "Installation complete! Please restart your terminal for all changes to take effect."
