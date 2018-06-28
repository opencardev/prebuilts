#!/bin/bash

# Set current folder as home
HOME="`cd $0 >/dev/null 2>&1; pwd`" >/dev/null 2>&1

# Switch to home directory
cd $HOME

# clone git repo
if [ ! -d gpio2kbd ]; then
    git clone -b master https://github.com/opencardev/gpio2kbd.git
else
    cd gpio2kbd
    git reset --hard
    git pull
    cd $HOME
fi

# Create inside build folder
cd $HOME/gpio2kbd
make

cd $HOME
