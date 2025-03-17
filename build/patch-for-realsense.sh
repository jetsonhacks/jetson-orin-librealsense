#!/bin/bash

# Default kernel source directory
DEFAULT_KERNEL_SRC="/usr/src/kernel/kernel-jammy-src"
KERNEL_SRC="$DEFAULT_KERNEL_SRC"

# Patch files with specific names
PATCH1="realsense-metadata-focal-hwe-5.15.patch"  # Streaming formats patch
# This is in the librealsense instructions, but have already been
# incorporated in to 5.15.148
# PATCH2="realsense-hid-focal-hwe-5.15.patch"      # accel/gyro fix patch
PATCH3="realsense-camera-formats-focal-hwe-5.15.patch"  # UVC metadata patch

# Store the original directory where the script and patches are located
ORIGINAL_DIR="$PWD"

# Function to display usage/help
usage() {
    echo "Usage: $0 [-d kernel_source_dir] [-h]"
    echo "Options:"
    echo "  -d  Specify the kernel source directory (default: $DEFAULT_KERNEL_SRC)"
    echo "  -h  Display this help message"
    echo "This script applies RealSense patches to a Linux kernel source for Ubuntu 20.04 (kernel 5.15)."
    echo "Note: You may need sudo privileges to modify kernel source files in system areas."
    exit 1
}

# Parse command-line options
while getopts "d:h" opt; do
    case $opt in
        d)
            KERNEL_SRC="$OPTARG"
            ;;
        h)
            usage
            ;;
        ?)
            usage
            ;;
    esac
done

# Function to check if a file exists
check_file() {
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found."
        exit 1
    fi
}

# Check if running kernel is 5.15
CURRENT_KERNEL=$(uname -r)
if [[ "$CURRENT_KERNEL" != 5.15* ]]; then
    echo "Error: This script is designed for kernel version 5.15. Current kernel is $CURRENT_KERNEL."
    echo "Please ensure you are running Ubuntu 20.04 with kernel 5.15."
    exit 1
fi

# Verify kernel source directory exists
if [ ! -d "$KERNEL_SRC" ]; then
    echo "Error: Kernel source directory '$KERNEL_SRC' does not exist."
    echo "Please provide a valid directory with -d option or ensure the default directory is correct."
    exit 1
fi

# Check if patch files exist in the original directory
check_file "$ORIGINAL_DIR/$PATCH1"
# check_file "$ORIGINAL_DIR/$PATCH2"
check_file "$ORIGINAL_DIR/$PATCH3"

# Check if required source files exist in the kernel source directory
REQUIRED_FILES=(
    "$KERNEL_SRC/drivers/media/usb/uvc/uvc_driver.c"
    "$KERNEL_SRC/drivers/media/usb/uvc/uvcvideo.h"
    "$KERNEL_SRC/drivers/media/v4l2-core/v4l2-ioctl.c"
    "$KERNEL_SRC/include/uapi/linux/videodev2.h"
    "$KERNEL_SRC/drivers/iio/accel/hid-sensor-accel-3d.c"
    "$KERNEL_SRC/drivers/iio/gyro/hid-sensor-gyro-3d.c"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Required kernel source file '$file' not found."
        exit 1
    fi
done

# Check if the user has write permissions to the kernel source directory
if [ ! -w "$KERNEL_SRC" ]; then
    echo "Warning: You do not have write permissions to '$KERNEL_SRC'."
    echo "The script will use 'sudo' to apply patches. You may be prompted for your password."
    SUDO="sudo"
else
    SUDO=""
fi

# Change to kernel source directory
cd "$KERNEL_SRC" || {
    echo "Error: Could not change to directory '$KERNEL_SRC'."
    exit 1
}

# Apply the patches with sudo if necessary
echo "Applying patch 1: $PATCH1 (Streaming formats)..."
$SUDO patch -p1 < "$ORIGINAL_DIR/$PATCH1"
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply $PATCH1."
    exit 1
fi

# echo "Applying patch 2: $PATCH2 (HID accel/gyro fix)..."
# $SUDO patch -p1 < "$ORIGINAL_DIR/$PATCH2"
# if [ $? -ne 0 ]; then
#    echo "Error: Failed to apply $PATCH2."
#    echo "Attempting to revert $PATCH1..."
#    $SUDO patch -R -p1 < "$ORIGINAL_DIR/$PATCH1"
#    exit 1
# fi

echo "Applying patch 2: $PATCH3 (UVC metadata attributes)..."
$SUDO patch -p1 < "$ORIGINAL_DIR/$PATCH3"
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply $PATCH3."
    echo "Attempting to revert $PATCH1..."
#    $SUDO patch -R -p1 < "$ORIGINAL_DIR/$PATCH2"
    $SUDO patch -R -p1 < "$ORIGINAL_DIR/$PATCH1"
    exit 1
fi

echo "All patches applied successfully to kernel source at '$KERNEL_SRC'."
echo "Next steps: See instructions."

exit 0
