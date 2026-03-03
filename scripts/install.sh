#!/bin/bash
#
# This script sets up the dotfiles repository. It can be run directly
# from a cloned repository or via curl | bash.

# Exit immediately if a command exits with a non-zero status.
set -e

# Helper function for logging
info() {
    echo "INFO: $1"
}

# --- Bootstrap Logic (for curl | bash) ---

# This section handles the initial cloning of the repository if the script
# is not already running from within the git repository.
bootstrap() {
    info "Running in bootstrap mode (via curl)."
    
    # Define repository details
    REPO_USER="RohiRIK"
    REPO_NAME="dotfiles"
    REPO_URL="https://github.com/$REPO_USER/$REPO_NAME.git"
    TARGET_DIR="$HOME/.dotfiles"

    # Check for Git
    if ! command -v git &> /dev/null; then
        info "Git is not installed. Please install Git and try again."
        exit 1
    fi

    # Clone or update the repository
    if [ -d "$TARGET_DIR" ]; then
        info "Updating existing dotfiles repository in $TARGET_DIR..."
        cd "$TARGET_DIR"
        git pull
    else
        info "Cloning dotfiles repository to $TARGET_DIR..."
        git clone "$REPO_URL" "$TARGET_DIR"
        cd "$TARGET_DIR"
    fi
    
    # Re-execute the script from the local clone
    info "Re-executing installer from local repository..."
    # The script is now in scripts/install.sh
    exec ./scripts/install.sh
    exit 0 # Exit after exec
}


# --- Main Installation Logic ---

main() {
    # Get the root directory of the Git repository
    REPO_ROOT=$(git rev-parse --show-toplevel)
    info "Running installer from repository root: $REPO_ROOT"

    # --- Step 1: Check and install Homebrew ---
    if ! command -v brew &> /dev/null; then
        info "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon
        if [[ $(uname -m) == "arm64" ]]; then
            info "Adding Homebrew to your PATH in .zprofile..."
            (echo; echo '''eval "$(/opt/homebrew/bin/brew shellenv)"''') >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        info "Homebrew is already installed."
    fi

    # --- Step 2: Run brew bundle ---
    info "Installing packages from Brewfile..."
    brew bundle install --file="$REPO_ROOT/brew/brewfile"

    # --- Step 3: Back up and link zshrc ---
    ZSHRC_PATH="$HOME/.zshrc"
    DOTFILES_ZSHRC_PATH="$REPO_ROOT/zsh/zshrc"

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

    # --- Step 5: Set up weekly updates via cron ---
    info "Setting up weekly updates..."

    # Define the command to be run
    # Using full paths for cron compatibility
    BREW_PATH=$(which brew)
    MAS_PATH=$(which mas)
    CRON_COMMAND="0 9 * * 1 $BREW_PATH update && $BREW_PATH upgrade && $MAS_PATH upgrade"
    CRON_JOB_COMMENT="# Homebrew weekly update"

    # Check if the cron job already exists and add it if it doesn't
    (crontab -l 2>/dev/null | grep -q "$CRON_JOB_COMMENT") || {
        info "Adding cron job for weekly updates (Monday at 9 AM)."
        (crontab -l 2>/dev/null; echo ""; echo "$CRON_JOB_COMMENT"; echo "$CRON_COMMAND") | crontab -
    }

    info "Installation complete! Please restart your terminal for all changes to take effect."
}


# --- Script Entrypoint ---

# If the script is not being run from within a git repository,
# assume it's the curl | bash scenario and run the bootstrap.
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    bootstrap
else
    main
fi