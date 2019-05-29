#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Clean build folder
sudo rm -rf $HOME/qt512_build

# Create build folders
mkdir -p $HOME/qt512/src
mkdir -p $HOME/qt512_build

# Check source packages
cd $HOME/qt512
if ! [ -f qt-everywhere-src-5.12.3.tar.xz ]; then
    wget https://download.qt.io/official_releases/qt/5.12/5.12.3/single/qt-everywhere-src-5.12.3.tar.xz
fi

# Unpack source
cd $HOME/qt512/src
if ! [ -d qt-everywhere-src-5.12.3 ]; then
    echo "Unpacking archive..."
    pv -p -w 80 $HOME/qt512/qt-everywhere-src-5.12.3.tar.xz | tar -J -xf - -C $HOME/qt512/src
fi

cd $HOME/qt-raspberrypi-configuration
sudo make install DESTDIR=$HOME/qt512/src/qt-everywhere-src-5.12.3

# Switch to build directory and build
cd $HOME/qt512_build

PKG_CONFIG_LIBDIR=/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig \
$HOME/qt512/src/qt-everywhere-src-5.12.3/configure -platform linux-rpi2-g++ \
-v \
-opengl es2 -eglfs \
-no-gtk \
-opensource -confirm-license -release \
-reduce-exports \
-force-pkg-config \
-nomake examples -no-compile-examples \
-skip qtwayland \
-skip qtwebengine \
-no-feature-geoservices_mapboxgl \
-qt-pcre \
-no-pch \
-ssl \
-evdev \
-system-freetype \
-fontconfig \
-glib \
-prefix /usr/local/qt5 \
-qpa eglfs

if [ $? -eq 0 ]; then
    sudo make -j2

    if [ $? -eq 0 ]; then
        sudo rm -rf /usr/local/qt5
        sudo make install
    else
        echo "make failed"
    fi
else
    echo "configure failed"
fi

cd $HOME
