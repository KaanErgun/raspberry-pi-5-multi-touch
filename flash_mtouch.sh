#!/bin/bash
set -e

# Configuration
EEPROM_BIN="mtouch.bin"
REQUIRED_CMDS=("dd" "grep" "sed" "lsb_release")
PACKAGES=("libraspberrypi-bin" "lsb-release")

echo "=== Raspberry Pi EEPROM Flash Script ==="

# Check if script is run on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/device-tree/model; then
    echo "Not running on a Raspberry Pi. Aborting."
    exit 1
fi

# Ensure required commands are available
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v $cmd &>/dev/null; then
        echo "Missing required command: $cmd"
        MISSING=true
    fi
done

# Install missing packages if needed
if [ "$MISSING" = true ]; then
    echo "Installing required packages..."
    sudo apt update
    for pkg in "${PACKAGES[@]}"; do
        sudo apt install -y "$pkg"
    done
fi

# Confirm binary exists
if [ ! -f "$EEPROM_BIN" ]; then
    echo "EEPROM binary '$EEPROM_BIN' not found in current directory: $(pwd)"
    exit 1
fi

# Show current EEPROM version
echo "--- Current EEPROM Version ---"
if command -v vcgencmd &> /dev/null; then
    vcgencmd bootloader_version || echo "Could not read current EEPROM version"
else
    echo "vcgencmd not available"
fi

# Locate EEPROM device
echo "--- Detecting EEPROM device ---"
EEPROM_DEV=$(grep -l "Raspberry Pi SPI EEPROM" /sys/class/mtd/*/name | sed 's|/name||')

if [ -z "$EEPROM_DEV" ]; then
    echo "EEPROM device not found. Trying fallback: /dev/mtd0"
    EEPROM_DEV="/dev/mtd0"
fi

if [ ! -e "$EEPROM_DEV" ]; then
    echo "EEPROM device $EEPROM_DEV not found. Aborting."
    exit 1
fi

echo "EEPROM device: $EEPROM_DEV"

# Backup current EEPROM
BACKUP_FILE="eeprom_backup_$(date +%Y%m%d_%H%M%S).bin"
echo "Backing up current EEPROM to $BACKUP_FILE..."
sudo dd if="$EEPROM_DEV" of="$BACKUP_FILE" bs=4k

# Flash new EEPROM
echo "Flashing new EEPROM from $EEPROM_BIN..."
sudo dd if="$EEPROM_BIN" of="$EEPROM_DEV" bs=4k conv=fsync
sync

echo "✅ Flash complete. Reboot required for changes to take effect."
