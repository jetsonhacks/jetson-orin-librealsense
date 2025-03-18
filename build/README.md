# Notes for building kernel modules

In order to enable the full capabilities of RealSense devices certain modifications in the kernel (driver) modules shall be applied, such as support of Depth-related streaming formats and access to per-frame metadata attributes. There is a small set of generic kernel changes that are mostly retrofitted with more advanced kernel versions aimed at improving the overall drivers stability.

For Linux kernel 5.15 there is a set of 3 recommended patches. In the JetPack 6.2 release (5.15.148-tegra kernel) one of the patches is already incorporated. The script patch-for-realsense.sh will apply those changes to the kernel sources.

That script assumes that the source for the kernel and modules have been prepared and built according to https://github.com/jetsonhacks/jetson-orin-kernel-builder . That is, the source for the kernel is in /usr/src/kernel/kernel-jammy-src. In testing, the kernel and the modules were built for the default configuration before applying the patches.

In order to apply the patches:
```bash
./patch-for-realsense.sh
```

After the patches have been applied, the next step is module configuration. The HID_SENSOR_HUB module should be set to 'm' (module). In addition, HID_SENSOR_ACCEL_3D and HID_SENSOR_GYRO_3D should be configured as 'm' (module). The Accelerometer and Gyroscope settings are for the RealSense devices with accelerometers and gyroscopes (such as the D435i).

You should consider using the kernel editors make menuconfig (CLI) or make xconfig (GUI) to make the configuration changes, as there are some other modules which will be reconfigured also.

After completing the configuration, compile the modules.

Then you are ready to install the modules.
