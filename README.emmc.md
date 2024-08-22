# eMMC

## Partitions

| Size   | Device    | mountpoint | usage                                             |
|--------|-----------|------------|---------------------------------------------------|
| 4 MiB  | mmcblk0p1 | /vendor    | serial number, license keys, calibration          |
| 4 MiB  | mmcblk0p2 | -          | RAUC U-Boot environment                           |
| 2 GiB  | mmcblk0p3 | /          | root-fs slot a                                    |
| 2 GiB  | mmcblk0p4 | /          | root-fs slot b                                    |
| >3 GiB | mmcblk0p5 | /home*     | user data in /home and overlays for /etc and /var |

(*) overlays are mounted to `/etc` and `/var`

Boot partitions of eMMC are used for the bootloader.

```sh
parted -s /dev/mmcblk0 mktable gpt
parted -s /dev/mmcblk0 mkpart vendor fat32 1 4MiB
parted -s /dev/mmcblk0 mkpart rauc   fat32 4MiB 8MiB
parted -s /dev/mmcblk0 mkpart root.0 ext4  8MiB 3GiB
parted -s /dev/mmcblk0 mkpart root.1 ext4  3GiB 6GiB
parted -s /dev/mmcblk0 mkpart user   ext4  6GiB 100%
mkfs.vfat /dev/mmcblk0p1 -n vendor
mkfs.vfat /dev/mmcblk0p2 -n rauc.env
mkfs.ext4 /dev/mmcblk0p3 -L root.0
mkfs.ext4 /dev/mmcblk0p4 -L root.1
mkfs.ext4 /dev/mmcblk0p5 -L user
parted -s /dev/mmcblk0 print
```

## eMMC Provisioning

## Enable eMMC boot partition

```sh
# This needs to be done only once for a new eMMC

# https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1168342/faq-am62x-how-to-check-and-configure-emmc-flash-rst_n-signal-to-support-warm_reset-from-emmc-booting-on-am62x-sk-e2
mmc rst-function 0 1

# activate boot partitions for booting from them
mmc partconf 0 1 1 1
mmc bootbus 0 2 0 0
```

# Install to eMMC manually

Boot from sd card and run the following commands:

```sh
# install bootloader(s) to eMMC boot partition
mount /dev/mmcblk1p1 /mnt && cd /mnt
echo 0 > /sys/block/mmcblk0boot0/force_ro
dd if=tiboot3.bin of=/dev/mmcblk0boot0 seek=0
dd if=tispl.bin of=/dev/mmcblk0boot0 seek=1024
dd if=u-boot.img of=/dev/mmcblk0boot0 seek=5120
cd && umount /mnt

# copy rootfs to /tmp (run from PC)
scp build/deploy-ti/images/sysworxx/sysworxx-image-default-sysworxx.tar.xz root@sysworxx

# install rootfs
dd if=/dev/zero of=/dev/mmcblk0 bs=1024 count=1024
parted -s /dev/mmcblk0 mktable msdos
parted -s /dev/mmcblk0 unit MiB mkpart primary ext4 0% 100%
partprobe /dev/mmcblk0
mkfs.ext4 -q -F /dev/mmcblk0p1
mount /dev/mmcblk0p1 /mnt
cd /mnt
xzcat /tmp/sysworxx-image-default-sysworxx.tar.xz | tar -xvf -
```

- Poweroff
- Switch DIP-SW 6 to "on"

```sh
mmc dev 0
load mmc 0:2 ${fdtaddr}  /boot/dtb/ti/k3-am623-systec-fallback.dtb
load mmc 0:2 ${loadaddr} /boot/Image
setenv bootargs console=${console} ${optargs} root=/dev/mmcblk0p2 rw rootfstype=ext4
booti ${loadaddr} ${rd_spec} ${fdtaddr}
```

## Links

- [Flash Linux to eMMC](https://dev.ti.com/tirex/explore/node?node=A__AdNWBqCVds4ZSqU9osT1tQ__AM62-ACADEMY__uiYMDcq__LATEST)
