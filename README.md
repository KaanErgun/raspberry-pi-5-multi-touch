# Raspberry Pi EEPROM Flash Script

This script automates downloading and flashing a custom EEPROM firmware (`pieeprom.bin`) for Raspberry Pi devices.

> ⚠️ **WARNING:** Flashing EEPROM firmware with an incompatible file can permanently brick your Raspberry Pi. Use this script only if you fully understand the risks.

## Features

- Downloads a specified EEPROM binary from GitHub.
- Calculates and displays the SHA256 checksum for manual verification.
- Prompts you for confirmation before flashing.
- Uses `rpi-eeprom-update` to stage the EEPROM update.
- Optionally reboots the device after flashing.

## Requirements

- Raspberry Pi OS with `rpi-eeprom-update` installed.
- `sudo` privileges.
- Internet access (to download `pieeprom.bin`).

## Usage

1. **Download the script:**

   ```bash
   wget -O flash-eeprom.sh https://your-repository-or-location/flash-eeprom.sh
   chmod +x flash-eeprom.sh
   ```

2. **Run the script:**

   ```bash
   ./flash-eeprom.sh
   ```

3. **Verify SHA256 checksum:**

   The script will display a checksum. You should compare this checksum with the expected one published by the firmware provider before proceeding.

4. **Confirm flashing:**

   You will be prompted:

   ```
   Do you really want to flash this EEPROM firmware? This may brick your device if incompatible. (yes/no):
   ```

   Type `yes` to continue, or `no` to abort.

5. **Reboot:**

   After flashing, you can choose to reboot immediately or later:

   ```
   Reboot now? (yes/no):
   ```

## Example Output

```text
[INFO] Downloading pieeprom.bin from GitHub...
[INFO] Calculating SHA256 checksum:
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  /tmp/pieeprom.bin
Do you really want to flash this EEPROM firmware? This may brick your device if incompatible. (yes/no): yes
[INFO] Flashing EEPROM...
*** EEPROM update output here ***
[INFO] EEPROM update staged. You must reboot for the changes to take effect.
Reboot now? (yes/no): yes
[INFO] Rebooting...
```

## Important Notes

- Always **back up important data** before performing EEPROM updates.
- Confirm the firmware compatibility with your specific Raspberry Pi model.
- If you are unsure, consult the official Raspberry Pi documentation:
  - [Raspberry Pi 5 EEPROM](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#updating-the-bootloader)
  - [rpi-eeprom-update](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#rpi-eeprom-update)

## License

This script is provided **as-is**, without warranty. Use at your own risk.
