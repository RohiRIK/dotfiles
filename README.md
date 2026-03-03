# My macOS Dotfiles

This repository contains my personal dotfiles for setting up a macOS environment for DevOps and Security work. The goal is to automate the setup of a new machine and maintain a consistent, productive development environment.

## What's Inside?

- **`brewfile`**: A comprehensive list of Homebrew packages, including CLI tools, GUI applications, and fonts. This is used with `brew bundle` to install everything at once.
- **`zshrc`**: A detailed Zsh shell configuration that includes Oh My Zsh, numerous plugins, custom aliases for modern tools (`eza`, `bat`, `fzf`), and various helper functions.
- **`ghostty/config`**: Terminal emulator configuration for [Ghostty](https://ghostty.org).
- **`backup.sh`**: A script to update the `brewfile` with your currently installed packages.

## Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/RohiRIK/dotfiles.git ~/dotfiles
    ```

2.  **Install all applications and tools:**
    ```bash
    cd ~/dotfiles
    brew bundle install
    ```

3.  **Link the `zshrc` file:**
    This will replace the default `.zshrc` with the one from this repository. Make sure to back up your existing `.zshrc` if you have one.
    ```bash
    ln -s ~/dotfiles/zshrc ~/.zshrc
    ```

4.  **Link the Ghostty config:**
    ```bash
    mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
    ln -s ~/dotfiles/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
    ```

5.  **Reload your shell:**
    Open a new terminal window or run the following command:
    ```bash
    source ~/.zshrc
    ```

Your machine is now set up with the software and shell configuration from this repository.

## Maintaining Your Dotfiles

To keep your `brewfile` updated with any new software you install, you can run the backup script:

```bash
./backup.sh
```

This will regenerate the `brewfile`, which you can then commit and push to your repository.
