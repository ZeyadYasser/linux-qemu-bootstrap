#!/bin/sh

set -e

echo "Installing required dependencies"
./install_dependencies.sh
echo "Cleaning existing build"
./clean.sh
echo "Building the disk image"
./build_img.sh
echo "Running QEMU"
qemu-system-x86_64 -serial mon:stdio -nographic -drive format=raw,file=tmp/disk.img -m 64M
