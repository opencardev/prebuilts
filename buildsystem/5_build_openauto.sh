#!/bin/bash
# Install Pre-reqs
sudo apt-get -y install cmake build-essential git
sudo apt-get -y install libboost-all-dev libusb-1.0.0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler pulseaudio librtaudio-dev libgps-dev 
sudo apt-get install -y libblkid-dev libtag1-dev libgles2-mesa-dev
#libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Switch to home directory
cd $HOME

# clone git repo
if [ ! -d openauto ]; then
    git clone -b crankshaft-ng https://github.com/opencardev/openauto.git
else
    cd openauto
    git reset --hard
    git pull
    cd $HOME
fi

# Clean build folder
rm -rf $HOME/openauto_build

# Create build folder
mkdir -p $HOME/openauto_build

# link needed libs
ln -s /opt/vc/lib/libbrcmEGL.so /usr/lib/arm-linux-gnueabihf/libEGL.so
ln -s /opt/vc/lib/libbrcmGLESv2.so /usr/lib/arm-linux-gnueabihf/libGLESv2.so
ln -s /opt/vc/lib/libbrcmOpenVG.so /usr/lib/arm-linux-gnueabihf/libOpenVG.so
ln -s /opt/vc/lib/libbrcmWFC.so /usr/lib/arm-linux-gnueabihf/libWFC.so

# Create inside build folder
cd $HOME/openauto_build
cmake -DCMAKE_BUILD_TYPE=Release -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="$HOME/aasdk/include" -DAASDK_LIBRARIES="$HOME/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="$HOME/aasdk_build" -DAASDK_PROTO_LIBRARIES="$HOME/aasdk/lib/libaasdk_proto.so" ../openauto
make

cd $HOME
