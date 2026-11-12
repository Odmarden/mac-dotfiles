#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting dotfiles installation from ${DOTFILES_DIR}..."

# 1. Install Homebrew if it's missing
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Load Homebrew into the current shell session (Apple Silicon / Intel)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

# 2. Install everything from the Brewfile
if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
    echo "Installing apps and tools from Brewfile..."
    brew bundle --file="${DOTFILES_DIR}/Brewfile"
fi

# 3. Helper to safely symlink files/folders (backs up existing non-symlink targets)
link_config() {
    local source_path="$1"
    local target_path="$2"

    mkdir -p "$(dirname "${target_path}")"

    if [ -L "${target_path}" ]; then
        rm "${target_path}"
    elif [ -e "${target_path}" ]; then
        local backup_path="${target_path}.backup.$(date +%Y%m%d%H%M%S)"
        echo "Backing up existing ${target_path} -> ${backup_path}"
        mv "${target_path}" "${backup_path}"
    fi

    ln -s "${source_path}" "${target_path}"
    echo "Linked ${target_path} -> ${source_path}"
}

# 4. Link terminal, editor, and app configurations
echo "Linking configuration files..."
link_config "${DOTFILES_DIR}/zshrc" "${HOME}/.zshrc"
link_config "${DOTFILES_DIR}/.hammerspoon" "${HOME}/.hammerspoon"
link_config "${DOTFILES_DIR}/ghostty" "${HOME}/.config/ghostty"
link_config "${DOTFILES_DIR}/nvim" "${HOME}/.config/nvim"
link_config "${DOTFILES_DIR}/yazi" "${HOME}/.config/yazi"

# 5. Optionally apply macOS system preferences
if [ -f "${DOTFILES_DIR}/macos.sh" ]; then
    if [[ "${1:-}" == "--macos" ]]; then
        bash "${DOTFILES_DIR}/macos.sh"
    else
        read -r -p "Apply macOS System Settings from macos.sh? [y/N] " reply
        if [[ "${reply}" =~ ^[Yy]$ ]]; then
            bash "${DOTFILES_DIR}/macos.sh"
        else
            echo "Skipped macos.sh. You can run it anytime with: ./macos.sh"
        fi
    fi
fi

echo "Setup complete! Remember to reload Hammerspoon and restart your terminal."
