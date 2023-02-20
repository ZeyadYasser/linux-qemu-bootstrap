#!/bin/sh

set -e

BUILD_DIR="tmp"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}

# Version 6.1.12
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.12.tar.xz"

# Download/Extract the kernel if it doesn't exist
mkdir -p linux
if [ ! -f "linux.tar.xz" ]; then
    wget ${KERNEL_URL} -O "linux.tar.xz"
fi
tar xvf "linux.tar.xz" --strip 1 -C linux

cd linux
# Build the kernel
make ARCH=x86_64 defconfig
make ARCH=x86_64 kvm_guest.config
make ARCH=x86_64 -j`nproc`