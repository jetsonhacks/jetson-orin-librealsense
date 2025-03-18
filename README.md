# jetson-orin-librealsense
Prebuilt kernel modules for running librealsense on Jerson Orin, JetPack 6, kernel 5.15.148-tegra. Includes build tools.

# Installing librealsense support kernel modules
Some patches to modules have been applied to support Realsense cameras. These are all standard in-tree Linux modules that have been compiled for JetPack 6.2 (Kernel 5.15.148-tegra).

The modules are distributed here in a tar file so we can do a checksum on them first. 
 
To install the modules for use with librealsense, first do a checksum
```
sha256sum -c install-modules.tar.gz.sha256
```

Then to expand the install-modules directory:
```bash
   tar -xzf install-modules.tar.gz
   cd install-modules
```

After switching to the install-module directory, we run the install script: 
```bash
sudo ./install-realsense-modules.sh
```

# Building librealsense kernel modules
To patch the kernel modules, build, enable and install them, see the build directory.

# Installing librealsense

## Instructions are taken in part from: https://github.com/IntelRealSense/librealsense/blob/master/doc/installation_jetson.md

These instructions are for using the Linux native kernel drivers for UVC, USB and HID (Video4Linux and IIO respectively). In order to enable the full capabilities of RealSense devices certain modifications in the kernel (driver) modules shall be applied, such as support of Depth-related streaming formats and access to per-frame metadata attributes. There is a small set of generic kernel changes that are mostly retrofitted with more advanced kernel versions aimed at improving the overall drivers stability. These modifications are built-in to the kernel modules in this repository.

### Instalation steps:

Before getting started, unplug the RealSense camera.

1. Register the Intel Realsense public key:
```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
```
2. Add the server to the list of repositories:
```bash
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
```
3. Install the RealSense SDK:
```bash
sudo apt-get install librealsense2-utils
sudo apt-get install librealsense2-dev
```

With the installation complete, reconnect the RealSense device and:
```bash
realsense-viewer
```

# Release Notes
## March, 2025
* Initial release
* Tested on JetPack 6, Jetson Linux 36.4.3, Linux kernel 5.15.148-tegra
* Tested on NVIDIA Jetson Orin Nano Super Developer Kit





