#!/bin/sh

ROOT_DIR=/home/$SUDO_USER/

QKTHINGS_DIR=$ROOT_DIR/qkthings
QKTHINGS_LOCAL=/home/$SUDO_USER
DEV_DIR=$QKTHINGS_DIR/dev
TOOLCHAIN_DIR=$QKTHINGS_LOCAL/qkthings_local/toolchain

apt-get install build-essential doxygen

git clone https://github.com/qkthings/qkthings.git
python qkthings/dev/python/setup.py install

python qkthings/dev/python/qkthings/toolman.py -t arduino -r $TOOLCHAIN_DIR --dist=linux
python qkthings/dev/python/qkthings/toolman.py -t efm32 -r $TOOLCHAIN_DIR --dist=linux

git clone https://github.com/qkthings/qkperipheral.git
git clone https://github.com/qkthings/qkprogram.git
git clone https://github.com/qkthings/qkdsp.git

