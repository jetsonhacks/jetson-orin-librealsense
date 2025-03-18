# Building librealsense from source

You can build librealsense from source. These are taken from the instructions at: https://github.com/IntelRealSense/librealsense/blob/master/doc/installation_jetson.md#building-from-source-using-native-backend

First clone the librealsense repository and make a build directory.

```bash
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
mkdir build && cd build
```

You use cmake to build the make file. First, load the prerequisites:
```bash
sudo apt update
sudo apt install libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev -y
sudo apt install v4l-utils
```

Then build the make file:
```bash
cmake .. -DBUILD_EXAMPLES=true \
-DBUILD_PYTHON_BINDINGS=bool:true \
-DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
-DPYTHON_EXECUTABLE=/usr/bin/python3.10 \
-DBUILD_WITH_CUDA=true \
-DCMAKE_CUDA_ARCHITECTURES=87 \
-DCHECK_FOR_UPDATES=true \
-DCMAKE_BUILD_TYPE=Debug \
-DFORCE_RSUSB_BACKEND=OFF
```

Once finished, make the library and install it:
```bash
make
sudo make install
```

You can test the build with:
```bash
realsense-viewer
```


