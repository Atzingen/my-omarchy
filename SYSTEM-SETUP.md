# System-Level Setup

This document describes system-level configurations that require root access or special setup beyond just copying config files.

## Mouse Thumb Wheel Volume Control

A Python script monitors the Logitech mouse thumb wheel and controls system volume via swayosd.

### Files Created

1. **Volume Control Script:**
   - Location: `~/.local/bin/mx-thumb-volume.py`
   - Backed up in: `configs/local-bin/mx-thumb-volume.py`
   - Purpose: Reads mouse thumb wheel events and controls volume
   - Dependencies: `python-evdev`, `swayosd`

2. **Udev Rules:**
   - Location: `/etc/udev/rules.d/99-input.rules`
   - Purpose: Allow user to read mouse input events without root
   - Content:
     ```
     KERNEL=="event*", SUBSYSTEM=="input", MODE="0660", GROUP="input"
     ```

### Setup Steps

1. **Install the script:**
   ```bash
   mkdir -p ~/.local/bin
   cp configs/local-bin/mx-thumb-volume.py ~/.local/bin/
   chmod +x ~/.local/bin/mx-thumb-volume.py
   ```

2. **Add user to input group:**
   ```bash
   sudo usermod -aG input $USER
   ```

   **IMPORTANT:** Log out and log back in for group membership to take effect.

3. **Create udev rules:**
   ```bash
   sudo tee /etc/udev/rules.d/99-input.rules << 'EOF'
   KERNEL=="event*", SUBSYSTEM=="input", MODE="0660", GROUP="input"
   EOF
   ```

4. **Reload udev rules:**
   ```bash
   sudo udevadm control --reload-rules
   sudo udevadm trigger
   ```

5. **Find your mouse device:**
   ```bash
   ls -la /dev/input/by-id/ | grep -i mouse
   evtest  # then select your mouse to see event number
   ```

   Update the `DEV_PATH` in `mx-thumb-volume.py` if needed (default: `/dev/input/event10`)

6. **Test the script:**
   ```bash
   /usr/bin/python3 ~/.local/bin/mx-thumb-volume.py
   ```

   Try using your mouse thumb wheel to verify it controls volume.

7. **The script is auto-started via Hyprland** (see `~/.config/hypr/autostart.conf`)

## Group Memberships

Current groups the user should be in:
- `gustavo` - Primary group
- `wheel` - Sudo access
- `docker` - Docker access
- `input` - Read input device events (required for mx-thumb-volume.py)

Verify with:
```bash
groups
```

## Hyprland Modifications

### autostart.conf
- Added: `exec-once = /usr/bin/python3 ~/.local/bin/mx-thumb-volume.py`
- Commented out various auto-launch applications (browsers, terminals, etc.)

### bindings.conf
- Terminal behavior modifications
- Workspace key adjustments
- macOS-style screenshot bindings (Ctrl+Shift+3/4)
- Removed problematic window rules

## Troubleshooting

### Mouse volume control not working

1. Check if script is running:
   ```bash
   ps aux | grep mx-thumb-volume
   ```

2. Check input group membership:
   ```bash
   groups | grep input
   ```

   If not present, add and **log out/in**:
   ```bash
   sudo usermod -aG input $USER
   ```

3. Check device path:
   ```bash
   ls -la /dev/input/event*
   evtest  # find your mouse event number
   ```

   Update `DEV_PATH` in the script if needed.

4. Check udev rules:
   ```bash
   cat /etc/udev/rules.d/99-input.rules
   ```

5. Manual test:
   ```bash
   pkill -f mx-thumb-volume
   /usr/bin/python3 ~/.local/bin/mx-thumb-volume.py
   ```
