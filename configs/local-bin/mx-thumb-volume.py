#!/usr/bin/python3
import subprocess
from evdev import InputDevice, ecodes

DEV_PATH = "/dev/input/event10"  # Logitech USB Receiver Mouse

def change_volume(direction: int) -> None:
    # INVERTED: positive → lower, negative → raise
    if direction > 0:
        cmd = ["swayosd-client", "--output-volume", "lower"]
    else:
        cmd = ["swayosd-client", "--output-volume", "raise"]
    subprocess.run(cmd)

def main() -> None:
    dev = InputDevice(DEV_PATH)
    for event in dev.read_loop():
        if event.type == ecodes.EV_REL and event.code == ecodes.REL_HWHEEL and event.value != 0:
            change_volume(event.value)

if __name__ == "__main__":
    main()
