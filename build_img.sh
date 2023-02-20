#!/bin/sh

# Make sure the kernel is built
if [ ! -f "tmp/linux/arch/x86_64/boot/bzImage" ]; then
   ./build_linux.sh
fi

BUILD_DIR="tmp"
mkdir -p "${BUILD_DIR}"
cd ${BUILD_DIR}

DISK_IMG="disk.img"
DISK_SIZE="32M"

# Initialize disk image
qemu-img create ${DISK_IMG} ${DISK_SIZE}

# Add MBR partition table in the first MiB and
# make an ext4 partition using the rest of space.
parted -s ${DISK_IMG} mktable msdos
parted -s ${DISK_IMG} mkpart primary ext4 "1M" "100%"
parted -s ${DISK_IMG} set 1 boot on

# Turn image into loopback device for mounting.
# --partscan enables partitions scanning.
# Our ext4 partion will be available at "${DISK_DEV}p1".
DISK_DEV=$(sudo losetup --partscan --find --show ${DISK_IMG})
FS_DEV="${DISK_DEV}p1"

# Format ext4 partition
sudo mkfs.ext4 -v ${FS_DEV}

# Mount disk image
mkdir -p mnt
sudo mount ${FS_DEV} mnt

# Set current user as owner to avoid using sudo while populating fs
sudo chown -R $USER mnt

# Install and configure bootloader
mkdir -p mnt/boot/grub2
sudo grub2-install -v --directory=/usr/lib/grub/i386-pc --boot-directory=mnt/boot ${DISK_DEV}

cat >mnt/boot/grub2/grub.cfg <<EOF
serial
terminal_input serial
terminal_output serial
set root=(hd0,1)
linux /boot/bzImage \
  root=/dev/sda1 \
  console=ttyS0 \
  init=/bin/hello_world
boot
EOF

# Copy our built kernel image
cp linux/arch/x86_64/boot/bzImage mnt/boot/bzImage

# Download/Install busybox version 1.35.0
BUSYBOX_URL="https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox"

if [ ! -f "busybox" ]; then
   wget ${BUSYBOX_URL}
fi

mkdir -p mnt/bin
cp busybox mnt/bin/busybox
chmod +x mnt/bin/busybox
ln -s /bin/busybox mnt/bin/sh
ln -s /bin/busybox mnt/bin/sleep
ln -s /bin/busybox mnt/bin/cat

# Our init program
cp ../ascii_art mnt/ascii_art
cat >mnt/bin/hello_world <<'EOF'
#!/bin/sh
cat /ascii_art
while true; do sleep 10000; done
EOF
chmod +x mnt/bin/hello_world

# Clean
sudo chown -R root:root mnt
sudo umount mnt
sudo losetup -d ${DISK_DEV}
