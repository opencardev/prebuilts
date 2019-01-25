#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Switch to home directory
cd $HOME

# clone git repo
if [ ! -d cam_overlay ]; then
    git clone https://github.com/meekys/cam_overlay.git
else
    cd cam_overlay
    git reset --hard
    git pull
    cd $HOME
fi

# Create inside build folder
cd $HOME/cam_overlay
make -j2

sleep 5
cd $HOME
