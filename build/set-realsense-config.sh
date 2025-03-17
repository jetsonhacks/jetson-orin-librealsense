#!/bin/bash

# Default kernel source directory
KERNEL_SRC="/usr/src/kernel/kernel-jammy-src/"

# List of config options to set as modules
CONFIGS=(
    "CONFIG_HID_SENSOR_HUB"
    "CONFIG_HID_SENSOR_IIO_COMMON"
    "CONFIG_HID_SENSOR_ACCEL_3D"
    "CONFIG_HID_SENSOR_GYRO_3D"
    "CONFIG_HID_SENSOR_IIO_TRIGGER"
)

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Sets specific Linux kernel HID sensor config options to 'm' (module)"
    echo
    echo "Options:"
    echo "  -h, --help          Display this help message and exit"
    echo "  -s, --source DIR    Specify kernel source directory (default: $KERNEL_SRC)"
    echo
    echo "Example:"
    echo "  $0                  # Use default kernel source directory"
    echo "  $0 -s /path/to/src  # Use custom kernel source directory"
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -s|--source)
            KERNEL_SRC="$2"
            shift # past argument
            shift # past value
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Config file path
CONFIG_FILE="$KERNEL_SRC/.config"

# Check if kernel source directory exists
if [ ! -d "$KERNEL_SRC" ]; then
    echo "Kernel source directory '$KERNEL_SRC' not found."
    exit 1
fi

# Check if .config file exists in the specified directory
if [ ! -f "$CONFIG_FILE" ]; then
    echo "No .config file found in $KERNEL_SRC. Please run 'make defconfig' or similar first."
    exit 1
fi

if [ ! -w "$CONFIG_FILE" ] ; then
    SUDO="sudo"
else
    SUDO=""
fi

# Function to set a config option to module
set_config_module() {
    local config=$1
    echo "Setting $config=m"
    # Using scripts/config from kernel source
    # Sets the options to modules "m"
    $SUDO "$KERNEL_SRC/scripts/config" --file "$CONFIG_FILE" --set-val "$config" m
    if [ $? -ne 0 ] ; then
        echo "Error: failed to set $config. Check permissions and kernel source."
        exit 1
    fi
}

# Process each config option
for config in "${CONFIGS[@]}"; do
    set_config_module "$config"
done

echo "Configuration complete in $KERNEL_SRC"
echo "You can verify with 'make menuconfig' or by checking $KERNEL_SRC/.config"
