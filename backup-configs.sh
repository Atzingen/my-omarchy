#!/bin/bash

# Backup script for Omarchy configs
# This script backs up important configuration files to the repo

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
CONFIGS_BACKUP="$REPO_DIR/configs"

echo "Backing up configs to $CONFIGS_BACKUP"

# Create backup directory structure
mkdir -p "$CONFIGS_BACKUP"

# List of config directories to backup
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

# List of individual config files to backup
CONFIG_FILES=(
    "starship.toml"
    "chromium-flags.conf"
    "brave-flags.conf"
)

# Local bin scripts to backup
LOCAL_BIN_SCRIPTS=(
    "mx-thumb-volume.py"
)

# Backup directories
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$CONFIG_DIR/$dir" ]; then
        echo "Backing up $dir..."
        rm -rf "$CONFIGS_BACKUP/$dir"
        cp -r "$CONFIG_DIR/$dir" "$CONFIGS_BACKUP/$dir"
    else
        echo "Skipping $dir (not found)"
    fi
done

# Backup individual files
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$CONFIG_DIR/$file" ]; then
        echo "Backing up $file..."
        cp "$CONFIG_DIR/$file" "$CONFIGS_BACKUP/$file"
    else
        echo "Skipping $file (not found)"
    fi
done

# Backup shell configs from home
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up .zshrc..."
    cp "$HOME/.zshrc" "$CONFIGS_BACKUP/.zshrc"
fi

if [ -f "$HOME/.zprofile" ]; then
    echo "Backing up .zprofile..."
    cp "$HOME/.zprofile" "$CONFIGS_BACKUP/.zprofile"
fi

# Backup local bin scripts
mkdir -p "$CONFIGS_BACKUP/local-bin"
for script in "${LOCAL_BIN_SCRIPTS[@]}"; do
    if [ -f "$HOME/.local/bin/$script" ]; then
        echo "Backing up $script..."
        cp "$HOME/.local/bin/$script" "$CONFIGS_BACKUP/local-bin/$script"
    else
        echo "Skipping $script (not found)"
    fi
done

# Update package lists
echo "Updating package lists..."
pacman -Qq > "$REPO_DIR/pacotes.txt"
flatpak list --app --columns=application > "$REPO_DIR/flatpak.txt"

echo "Backup complete!"
echo ""
echo "To commit these changes, run:"
echo "  cd $REPO_DIR"
echo "  git add ."
echo "  git commit -m \"Update configs and package lists\""
echo "  git push"
