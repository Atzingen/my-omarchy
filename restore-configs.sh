#!/bin/bash

# Restore script for Omarchy configs
# This script restores configuration files from the repo

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
CONFIGS_BACKUP="$REPO_DIR/configs"

echo "Restoring configs from $CONFIGS_BACKUP"

# Check if backup directory exists
if [ ! -d "$CONFIGS_BACKUP" ]; then
    echo "Error: Configs backup directory not found!"
    echo "Please run backup-configs.sh first or clone a repo with existing configs."
    exit 1
fi

# List of config directories to restore
CONFIG_DIRS=(
    "hypr"
    "waybar"
    "mako"
    "alacritty"
    "nvim"
    "fastfetch"
    "btop"
    "lazygit"
    "walker"
    "elephant"
    "swayosd"
    "mise"
    "kitty"
    "imv"
)

# List of individual config files to restore
CONFIG_FILES=(
    "starship.toml"
    "chromium-flags.conf"
    "brave-flags.conf"
)

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Restore directories
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$CONFIGS_BACKUP/$dir" ]; then
        echo "Restoring $dir..."
        rm -rf "$CONFIG_DIR/$dir"
        cp -r "$CONFIGS_BACKUP/$dir" "$CONFIG_DIR/$dir"
    else
        echo "Skipping $dir (backup not found)"
    fi
done

# Restore individual files
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$CONFIGS_BACKUP/$file" ]; then
        echo "Restoring $file..."
        cp "$CONFIGS_BACKUP/$file" "$CONFIG_DIR/$file"
    else
        echo "Skipping $file (backup not found)"
    fi
done

# Restore shell configs to home
if [ -f "$CONFIGS_BACKUP/.zshrc" ]; then
    echo "Restoring .zshrc..."
    cp "$CONFIGS_BACKUP/.zshrc" "$HOME/.zshrc"
fi

if [ -f "$CONFIGS_BACKUP/.zprofile" ]; then
    echo "Restoring .zprofile..."
    cp "$CONFIGS_BACKUP/.zprofile" "$HOME/.zprofile"
fi

# Restore local bin scripts
if [ -d "$CONFIGS_BACKUP/local-bin" ]; then
    echo "Restoring local bin scripts..."
    mkdir -p "$HOME/.local/bin"
    for script in "$CONFIGS_BACKUP/local-bin"/*; do
        if [ -f "$script" ]; then
            echo "Restoring $(basename "$script")..."
            cp "$script" "$HOME/.local/bin/"
            chmod +x "$HOME/.local/bin/$(basename "$script")"
        fi
    done
fi

echo "Restore complete!"
echo ""
echo "You may need to:"
echo "  - Restart your shell or run: source ~/.zshrc"
echo "  - Restart Hyprland or reload configs"
echo "  - Restart other applications to pick up new configs"
