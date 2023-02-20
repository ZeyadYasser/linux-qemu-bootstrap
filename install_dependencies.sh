#!/bin/sh

sudo apt-get -y update
sudo apt-get -y install \
    tar wget build-essential libncurses-dev bison flex \
    libssl-dev libelf-dev grub2 qemu-kvm qemu-utils \
    libvirt-clients libvirt-daemon-system bridge-utils \
    virtinst libvirt-daemon e2fsprogs parted mount
sudo systemctl enable --now libvirtd
