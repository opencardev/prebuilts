#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Switch to home directory
cd $HOME

# clone git repo
if [ ! -d aasdk ]; then
    git clone -b development https://github.com/opencardev/aasdk.git
else
    cd aasdk
    git reset --hard
    git clean -d -x -f
    git pull
    cd $HOME
fi

# Clean build folder
sudo rm -rf $HOME/aasdk_build

# Create build folder
mkdir -p $HOME/aasdk_build

# Create inside build folder
cd $HOME/aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j2

cd $HOME
