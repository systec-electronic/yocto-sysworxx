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

## eMMC Provisioning (only needed for new eMMC)

In u-boot run:

```sh
# This needs to be done only once for a new eMMC

# https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1168342/faq-am62x-how-to-check-and-configure-emmc-flash-rst_n-signal-to-support-warm_reset-from-emmc-booting-on-am62x-sk-e2
mmc rst-function 0 1

# activate boot partitions for booting from them
mmc partconf 0 1 1 1
mmc bootbus 0 2 0 0
```

Run `bringup.sh` in Linux to install root file systems (including RAUC support)
ro eMMC.

## Links

- [Flash Linux to eMMC](https://dev.ti.com/tirex/explore/node?node=A__AdNWBqCVds4ZSqU9osT1tQ__AM62-ACADEMY__uiYMDcq__LATEST)
