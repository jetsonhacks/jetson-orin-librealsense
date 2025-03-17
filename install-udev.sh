#!/bin/bash

# Define source and destination paths
SOURCE_FILE="config/99-realsense-libusb.rules"
UDEV_DIR="/etc/udev/rules.d/"

# Check if the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE not found!"
    exit 1
fi

# Check if script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run this script with sudo privileges"
    exit 1
fi

# Copy the rules file to udev directory
echo "Installing udev rules..."
cp "$SOURCE_FILE" "$UDEV_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy rules file"
    exit 1
fi

# Reload udev rules
echo "Reloading udev rules..."
udevadm control --reload-rules
if [ $? -ne 0 ]; then
    echo "Error: Failed to reload udev rules"
    exit 1
fi

# Trigger udev rules
echo "Triggering udev rules..."
udevadm trigger
if [ $? -ne 0 ]; then
    echo "Error: Failed to trigger udev rules"
    exit 1
fi

echo "Udev rules successfully installed and activated!"
exit 0
