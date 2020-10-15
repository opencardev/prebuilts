#!/bin/bash

# Copy aasdk so's
if [ -f ./buildsystem/BINARY_FILES/libaasdk.so ]; then
    cp ./buildsystem/BINARY_FILES/libaasdk.so ./openauto/
fi

if [ -f ./buildsystem/BINARY_FILES/libaasdk_proto.so ]; then
    cp ./buildsystem/BINARY_FILES/libaasdk_proto.so ./openauto/
fi

# Copy Qt
if [ -f ./buildsystem/BINARY_FILES/Qt*_OpenGLES2.tar.xz.part00 ]; then
    cp ./buildsystem/BINARY_FILES/Qt* ./qt5/
fi

# Copy openauto
if [ -f ./buildsystem/BINARY_FILES/autoapp ]; then
    cp ./buildsystem/BINARY_FILES/autoapp ./openauto/
fi

if [ -f ./buildsystem/BINARY_FILES/btservice ]; then
    cp ./buildsystem/BINARY_FILES/btservice ./openauto/
fi

# Copy gpio2kbd
if [ -f ./buildsystem/BINARY_FILES/gpio2kbd ]; then
    cp ./buildsystem/BINARY_FILES/gpio2kbd ./gpio2kbd/
fi

# Copy cam_overlay.bin
if [ -f ./buildsystem/BINARY_FILES/cam_overlay.bin ]; then
    cp ./buildsystem/BINARY_FILES/cam_overlay.bin ./cam_overlay/
fi

cd csmt
md5sum $(basename crankshaft) > crankshaft.md5
cd ..

cd gpio2kbd
md5sum $(basename gpio2kbd) > gpio2kbd.md5
cd ..

cd openauto
md5sum $(basename autoapp) > autoapp.md5
md5sum $(basename autoapp_helper) > autoapp_helper.md5
md5sum $(basename btservice) > btservice.md5
md5sum $(basename libaasdk.so) > libaasdk.so.md5
md5sum $(basename libaasdk_proto.so) > libaasdk_proto.so.md5
cd ..

cd udev
md5sum $(basename 51-android.rules) > 51-android.rules.md5
cd ..

cd usbreset
md5sum $(basename usbreset) > usbreset.md5
cd ..

cd cam_overlay
md5sum $(basename cam_overlay.bin) > cam_overlay.bin.md5
cd ..
