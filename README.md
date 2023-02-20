# linux-qemu-bootstrap
This is the repository for exercise 1 of my techincal task (Create a bootable Linux image via QEMU).
This includes the bonus part of creating a fully bootable filesystem image which includes a bootloader (grub2).

## Quickstart
Please run `build_and_run.sh` with root privileges.

## Manual build and run
- Install dependencies -> `install_dependencies.sh`
- Clean existing build -> `clean.sh` (not required but recommended)
- Build the disk image -> `build_img.sh`
- Run image using QEMU -> `qemu-system-x86_64 -serial mon:stdio -nographic -drive format=raw,file=tmp/disk.img -m 64M`

You can optionally build the kernel without the rest of filesystem using `build_linux.sh`. This is not needed since it will be build as part of building the disk image.

You can customize the hello world message by editing the `ascii_art` file.

For more details please check `build_img.sh`.

## Output files
- Disk image -> `tmp/disk.img`
- Kernel image -> `tmp/linux/arch/x86_64/boot/bzImage`
