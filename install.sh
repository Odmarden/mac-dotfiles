#!/bin/bash

echo "Starting dotfiles installation..."

# 1. Install Homebrew if it's missing
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

# 2. Install everything from the Brewfile
if [ -f "Brewfile" ]; then
    echo "Installing apps from Brewfile..."
    brew bundle
fi

# 3. Create Symlinks
echo "Setting up Hammerspoon config..."
mkdir -p ~/.hammerspoon
# Use PWD to get the current directory of the script
ln -sf "$PWD/init.lua" ~/.hammerspoon/init.lua

echo "Setup complete! Remember to reload Hammerspoon."
