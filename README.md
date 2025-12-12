# My Omarchy Configuration

This repository contains all my Omarchy Linux configurations and a complete list of installed applications for easy system recovery and migration.

## Quick Setup

### System Update
```bash
sudo pacman -Syu
```

### Install Packages from List
```bash
# Install all packages from pacotes.txt
yay -S --needed - < pacotes.txt
```

### Install Flatpak Apps
```bash
# Install all flatpak apps from flatpak.txt (if any)
flatpak install -y $(cat flatpak.txt)
```

## Package Lists

### Pacman/AUR Packages
- **File:** `pacotes.txt`
- **Count:** 1078 packages
- **Update command:**
  ```bash
  pacman -Qq > pacotes.txt
  ```

### Flatpak Applications
- **File:** `flatpak.txt`
- **Update command:**
  ```bash
  flatpak list --app --columns=application > flatpak.txt
  ```

## Configuration Files

### Important Configs to Backup

The following directories should be backed up from `~/.config`:

- `hypr/` - Hyprland configuration
- `waybar/` - Waybar configuration
- `mako/` - Notification daemon
- `alacritty/` - Terminal emulator
- `nvim/` - Neovim configuration
- `fastfetch/` - System info tool
- `btop/` - System monitor
- `lazygit/` - Git UI
- `walker/` - Application launcher
- `electron/` - Elephant launcher config
- `swayosd/` - OSD configuration
- `starship.toml` - Shell prompt
- `chromium-flags.conf` - Chromium flags
- `brave-flags.conf` - Brave browser flags

### Shell Configuration
- `~/.zshrc` - Zsh configuration
- `~/.zprofile` - Zsh profile

## Key Applications

### Development Tools
- Visual Studio Code (`visual-studio-code-bin`)
- Neovim (`neovim`, `omarchy-nvim`)
- Git (`git`, `github-cli`, `lazygit`)
- Docker (`docker`, `docker-compose`, `lazydocker`)
- DBeaver (`dbeaver-ce-bin`)

### Desktop Environment
- Hyprland (`hyprland`)
- Waybar (`waybar`)
- Walker launcher (`walker`, `omarchy-walker`)
- Elephant launcher (`elephant`)
- Mako notifications (`mako`)

### Browsers
- Google Chrome (`google-chrome`)
- Brave (`brave-bin`)
- Omarchy Chromium (`omarchy-chromium`)

### Communication
- Signal (`signal-desktop`)
- Slack (`slack-desktop`)
- Telegram (`telegram-desktop`)

### Multimedia
- OBS Studio (`obs-studio`)
- VLC (`vlc-plugins-*`)
- MPV (`mpv`)
- Spotify (`spotify`)
- Kdenlive (`kdenlive`)

### Utilities
- 1Password (`1password-beta`, `1password-cli`)
- Typora (`typora`)
- Obsidian (`obsidian`)
- LibreOffice (`libreoffice-fresh`)

## Additional Apps to Install Manually

### nwg-displays
Display configuration tool for Hyprland/Wayland

**Repository:** https://github.com/nwg-piotr/nwg-displays

```bash
yay -S nwg-displays
```

## System Information

- **Distribution:** Omarchy Linux (Arch-based)
- **Desktop:** Hyprland
- **Shell:** Zsh with Starship prompt
- **Terminal:** Alacritty
- **Kernel:** 6.17.7-arch1-2

## Maintenance Commands

### Update Package List
```bash
cd /home/gustavo/Desktop/dev/my-omarchy
pacman -Qq > pacotes.txt
flatpak list --app --columns=application > flatpak.txt
git add pacotes.txt flatpak.txt
git commit -m "Update package lists"
git push
```

### Clean Package Cache
```bash
yay -Sc
```

### Remove Orphaned Packages
```bash
yay -Yc
```

## Notes

- This configuration is tailored for Omarchy Linux
- Some packages are from AUR (requires `yay` or another AUR helper)
- Always review package lists before bulk installing
- Backup your data before doing a fresh install
