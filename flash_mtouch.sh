#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# URL of the pieeprom.bin file
URL="https://github.com/KaanErgun/raspberry-pi-5-multi-touch/raw/main/pieeprom.bin"

# Target path to save the file
TARGET_PATH="/tmp/pieeprom.bin"

# Download the file
echo "[INFO] Downloading pieeprom.bin from GitHub..."
wget -O "$TARGET_PATH" "$URL"

# Calculate SHA256 checksum
echo "[INFO] Calculating SHA256 checksum:"
sha256sum "$TARGET_PATH"

# Confirm with the user before flashing
read -p "Do you really want to flash this EEPROM firmware? This may brick your device if incompatible. (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "[INFO] Aborting."
    exit 0
fi

# Flash the EEPROM using rpi-eeprom-update
echo "[INFO] Flashing EEPROM..."
sudo rpi-eeprom-update -d -f "$TARGET_PATH"

# Inform the user
echo "[INFO] EEPROM update staged. You must reboot for the changes to take effect."

# Prompt to reboot
read -p "Reboot now? (yes/no): " reboot_confirm
if [[ "$reboot_confirm" == "yes" ]]; then
    echo "[INFO] Rebooting..."
    sudo reboot
else
    echo "[INFO] Please reboot manually to complete the update."
fi
