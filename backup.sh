#!/bin/bash
#
# Updates the Brewfile with the currently installed packages.

# Change to the directory where the script is located to ensure Brewfile is found
cd "$(dirname "$0")" || exit

echo "Updating Brewfile..."
brew bundle dump --force
echo "Brewfile updated successfully."
