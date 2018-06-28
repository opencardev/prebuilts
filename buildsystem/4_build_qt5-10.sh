#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Clean build folder
sudo rm -rf $HOME/qt510_build/src
sudo rm -rf $HOME/qt510_build

# Create build folders
mkdir -p $HOME/qt510_build/src
mkdir -p $HOME/qt510

# Check source packages
cd $HOME/qt510
if ! [ -f qt-everywhere-src-5.10.1.tar.xz ]; then
    wget https://download.qt.io/official_releases/qt/5.10/5.10.1/single/qt-everywhere-src-5.10.1.tar.xz
fi

# Unpack source
cd $HOME/qt510_build/src
if ! [ -d qt-everywhere-src-5.10.1 ]; then
    echo "Unpacking archive..."
    pv -p -w 80 $HOME/qt510/qt-everywhere-src-5.10.1.tar.xz | tar -J -xf - -C $HOME/qt510_build/src
fi

# Switch to build directory and build
cd $HOME/qt510_build

./src/qt-everywhere-src-5.10.1/configure \
-v -opengl es2 -eglfs -no-gtk -device linux-rasp-pi-g++ -device-option CROSS_COMPILE=/usr/bin/ -opensource -confirm-license \
-optimized-qmake -reduce-exports -release -prefix /usr/local/qt5 -sysroot / -fontconfig -glib -recheck -evdev -ssl -qt-xcb \
-make libs -nomake examples -no-compile-examples -nomake tests -skip qt3d -skip qtandroidextras -skip qtcanvas3d -skip qtcharts \
-skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtmacextras -skip qtpurchasing -skip qtscript -skip qtscxml \
-skip qtspeech -skip qtsvg -skip qttools -skip qttranslations -skip qtwebchannel -skip qtwebengine -skip qtwebsockets \
-skip qtwebview -skip qtwinextras -skip qtxmlpatterns -no-feature-textodfwriter -no-feature-dom -no-feature-calendarwidget \
-no-feature-printpreviewwidget -no-feature-keysequenceedit -no-feature-colordialog -no-feature-printpreviewdialog \
-no-feature-wizard -no-feature-datawidgetmapper -no-feature-imageformat_ppm -no-feature-imageformat_xbm \
-no-feature-image_heuristic_mask -no-feature-cups -no-feature-paint_debug -no-feature-translation -no-feature-ftp \
-no-feature-socks5 -no-feature-bearermanagement -no-feature-fscompleter -no-feature-desktopservices -no-feature-mimetype \
-no-feature-undocommand -no-feature-undostack -no-feature-undogroup -no-feature-undoview -no-feature-statemachine

make -j4
sudo rm -rf /usr/local/qt5
sudo make install

cd $HOME
