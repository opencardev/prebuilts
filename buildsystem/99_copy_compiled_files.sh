#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Create output folder
if [ ! -d BINARY_FILES ]; then
    mkdir BINARY_FILES
fi

# Copy aasdk so's
if [ -f ./aasdk/lib/libaasdk.so ]; then
    cp ./aasdk/lib/libaasdk.so ./BINARY_FILES/
fi

if [ -f ./aasdk/lib/libaasdk_proto.so ]; then
    cp ./aasdk/lib/libaasdk_proto.so ./BINARY_FILES/
fi

# Copy openauto
if [ -f ./openauto/bin/autoapp ]; then
    cp ./openauto/bin/autoapp ./BINARY_FILES/
fi

if [ -f ./openauto/bin/btservice ]; then
    cp ./openauto/bin/btservice ./BINARY_FILES/
fi

# Copy gpio2kbd
if [ -f ./gpio2kbd/gpio2kbd ]; then
    cp ./gpio2kbd/gpio2kbd ./BINARY_FILES/
fi

# Copy cam_overlay.bin
if [ -f ./cam_overlay/cam_overlay.bin ]; then
    cp ./cam_overlay/cam_overlay.bin ./BINARY_FILES/
fi

# Create compressed qt5
QTVERSON=`cat /usr/local/qt5/lib/pkgconfig/Qt5Core.pc | grep Version: | cut -d: -f2 | sed 's/ //g' | sed 's/\.//g'`

tar -cvf $HOME/BINARY_FILES/Qt_${QTVERSON}_OpenGLES2.tar.xz /usr/local/qt5
split -b 50m -d $HOME/BINARY_FILES/Qt_${QTVERSON}_OpenGLES2.tar.xz "$HOME/BINARY_FILES/Qt_${QTVERSON}_OpenGLES2.tar.xz.part"
rm $HOME/BINARY_FILES/Qt_${QTVERSON}_OpenGLES2.tar.xz

cd $HOME
