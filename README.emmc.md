# Manual programming and booting eMMC (from working SD card)

## Copy file system

```sh
cat /dev/mmcblk1 > /dev/mmcblk0
dd if=tiboot3.bin of=/dev/mmcblk0boot0 seek=0
dd if=tispl.bin of=/dev/mmcblk0boot0 seek=1024
dd if=u-boot.img of=/dev/mmcblk0boot0 seek=5120
```

## Enable eMMC boot partition

```sh
# This needs to be done only once for a new eMMC
=> mmc partconf 0 1 1 1
=> mmc bootbus 0 2 0 0
```

## Boot from eMMC

- Poweroff
- Switch DIP-SW 6 to "on"
- Power on and enter U-Boot shell

```sh
mmc dev 0
load mmc 0:2 ${fdtaddr}  /boot/dtb/ti/k3-am623-systec-fallback.dtb
load mmc 0:2 ${loadaddr} /boot/Image
setenv bootargs console=${console} ${optargs} root=/dev/mmcblk0p2 rw rootfstype=ext4
booti ${loadaddr} ${rd_spec} ${fdtaddr}
```

## Links

- [Flash Linux to eMMC](https://dev.ti.com/tirex/explore/node?node=A__AdNWBqCVds4ZSqU9osT1tQ__AM62-ACADEMY__uiYMDcq__LATEST)
