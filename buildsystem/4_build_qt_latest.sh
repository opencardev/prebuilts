#!/bin/bash

# Set variables
QT_URL=https://download.qt.io/official_releases/qt/
QT_VERSION=$(curl -s $QT_URL | grep -oE -m1 href=\"[0-9\.]+ |  tr -d 'href="')
QT_VERSION='5.15'
QT_FULL_VERSION=$(curl -s $QT_URL$QT_VERSION/ | grep -oE -m1 href=\"[0-9\.]+ |  tr -d 'href="')
QT_FULL_VERSION='5.15.1'
QT_FILENAME=qt-everywhere-src-${QT_FULL_VERSION}.tar.xz
DEVICE_OPT=linux-rasp-pi3-g++
if [ -z "${CPU_CORES_COUNT}"]; then
  CPU_CORES_COUNT=`grep -c ^processor /proc/cpuinfo`
fi
# Lookup for PI version
PIVERSION=`grep ^Model /proc/cpuinfo` 
if [[ ${PIVERSION} =~ 'Raspberry Pi 3' ]]; then
   DEVICE_OPT=linux-rasp-pi3-vc4-g++
   KMS='-kms'
elif [[ ${PIVERSION} =~ 'Raspberry Pi 4' ]]; then
   DEVICE_OPT=linux-rasp-pi4-v3d-g++
   KMS='-kms'
elif [[ ${PIVERSION} =~ 'Raspberry Pi 2' ]]; then
   DEVICE_OPT=linux-rasp-pi2-g++
   KMS='-kms'
else
   DEVICE_OPT=linux-rasp-pi-g++
   KMS='-kms'
fi
# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

QT_FILE_VERSION=$(echo $QT_VERSION | tr -d '.')

echo "Building latest QT version: $QT_FULL_VERSION with EGL support"

# Clean build folder
#sudo rm -rf ${HOME}/qt${QT_FILE_VERSION}_build

# Create build folders
mkdir -p ${HOME}/qt${QT_FILE_VERSION}/src
mkdir -p ${HOME}/qt${QT_FILE_VERSION}_build

# Check source packages
cd ${HOME}/qt${QT_FILE_VERSION}
if ! [ -f ${QT_FILENAME} ]; then
    wget ${QT_URL}${QT_VERSION}/${QT_FULL_VERSION}/single/${QT_FILENAME}
fi

# Unpack source
cd ${HOME}/qt${QT_FILE_VERSION}/src

if ! [ -d qt-everywhere-src-${QT_FULL_VERSION} ]; then
    echo "Unpacking archive..."
    pv -p -w 80 ${HOME}/qt${QT_FILE_VERSION}/${QT_FILENAME} | tar -J -xf - -C ${HOME}/qt${QT_FILE_VERSION}/src
fi

# Switch to build directory and build
cd ${HOME}/qt${QT_FILE_VERSION}_build

QT_QPA_EGLFS_KMS_CONFIG=${HOME}/eglfs.json
PKG_CONFIG_LIBDIR=/usr/lib/arm-linux-gnueabihf/pkgconfig:/usr/share/pkgconfig \
${HOME}/qt${QT_FILE_VERSION}/src/qt-everywhere-src-${QT_FULL_VERSION}/configure -device ${DEVICE_OPT} \
-device-option CROSS_COMPILE=arm-linux-gnueabihf- \
-sysroot / \
-opengl es2 -eglfs -linuxfb ${KMS} -xcb \
-prefix /usr/local/qt5 \
-opensource -confirm-license \
-release -v \
-nomake examples -no-compile-examples \
-no-use-gold-linker \
-recheck-all \
-skip qtwebengine \
-skip qtwayland \
-no-gtk \
-reduce-exports \
-force-pkg-config \
-qt-pcre \
-no-pch \
-ssl \
-evdev \
-system-freetype \
-fontconfig \
-glib \
-qpa eglfs \
-make libs -optimized-qmake  -skip qt3d -skip qtandroidextras -skip qtcanvas3d -skip qtcharts \
-skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtmacextras -skip qtpurchasing -skip qtscript -skip qtscxml \
-skip qtspeech -skip qtsvg -skip qttools -skip qttranslations -skip qtwebchannel -skip qtwebsockets \
-skip qtwebview -skip qtwinextras -skip qtxmlpatterns -no-feature-textodfwriter -no-feature-dom -no-feature-calendarwidget \
-no-feature-printpreviewwidget -no-feature-keysequenceedit -no-feature-colordialog -no-feature-printpreviewdialog \
-no-feature-wizard -no-feature-datawidgetmapper -no-feature-imageformat_ppm -no-feature-imageformat_xbm \
-no-feature-image_heuristic_mask -no-feature-cups -no-feature-translation -no-feature-ftp \
-no-feature-socks5 -no-feature-bearermanagement -no-feature-fscompleter -no-feature-desktopservices -no-feature-mimetype \
-no-feature-undocommand -no-feature-undostack -no-feature-undogroup -no-feature-undoview -no-feature-statemachine \
2>&1 | tee ../configure$(date +"%Y-%m-%d_%H-%M").log

if [ $? -eq 0 ]; then
    sudo make -j$CPU_CORES_COUNT 2>&1 | tee ../make$(date +"%Y-%m-%d_%H-%M").log
    if [ $? -eq 0 ]; then
        sudo rm -rf /usr/local/qt5
        sudo make install 2>&1 | tee ../install$(date +"%Y-%m-%d_%H-%M").log
        echo "Building of QT $QT_FULL_VERSION finished successfully."
    else
        echo "make failed"
    fi
else
    echo "configure failed"
fi

cd ${HOME}
