#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Clean build folder
sudo rm -rf $HOME/qt511_build/src
sudo rm -rf $HOME/qt511_build

# Create build folders
mkdir -p $HOME/qt511_build/src
mkdir -p $HOME/qt511

# Check source packages
cd $HOME/qt511
if ! [ -f qt-everywhere-src-5.11.2.tar.xz ]; then
    wget https://download.qt.io/official_releases/qt/5.11/5.11.2/single/qt-everywhere-src-5.11.2.tar.xz
fi

# Unpack source
cd $HOME/qt511_build/src
if ! [ -d qt-everywhere-src-5.11.2 ]; then
    echo "Unpacking archive..."
    pv -p -w 80 $HOME/qt511/qt-everywhere-src-5.11.2.tar.xz | tar -J -xf - -C $HOME/qt511_build/src
fi

# Switch to build directory and build
cd $HOME/qt511_build

./src/qt-everywhere-src-5.11.2/configure \
-v -opengl es2 -no-gtk -device linux-rasp-pi2-g++ -device-option CROSS_COMPILE=/usr/bin/ -opensource -confirm-license \
-optimized-qmake -reduce-exports -release -prefix /usr/local/qt5 -sysroot / -fontconfig -glib -recheck -evdev -ssl -qt-xcb \
-make libs -nomake examples -no-compile-examples -nomake tests -skip qt3d -skip qtandroidextras -skip qtcanvas3d -skip qtcharts \
-skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtmacextras -skip qtpurchasing -skip qtscript -skip qtscxml \
-skip qttools -skip qtwebengine -no-use-gold-linker -skip qtwayland -no-gbm \
-skip qtspeech -skip qtsvg -skip qttranslations -system-freetype -fontconfig \

sudo make -j2
sudo rm -rf /usr/local/qt5
sudo make install

cd $HOME
