# jetson-orin-librealsense
Prebuilt kernel modules for running librealsense on Jerson Orin, JetPack 6. Includes build tools.
# WIP

# Installing librealsense support kernel modules
Some patches to modules have been applied to support Realsense cameras. These are all standard in-tree Linux modules that have been compiled for JetPack 6.2 (Kernel 5.15.148-tegra).

The modules are distributed here in a tar file so we can do a checksum on them first. 
 
To install the modules for use with librealsense, first do a checksum
```
$ sha256sum -c install-modules.tar.gz.sha256
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
   
### UDEV rules
To install the UDEV rules for the Realsense cameras:
```bash
sudo ./install-udev.sh
```

