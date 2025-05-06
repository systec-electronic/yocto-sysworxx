#!/bin/sh

# e.g. 'mmcblk0' (for emmc) 'mmcblk1' (for sd card)
parent=$1

for arg in $(cat /proc/cmdline); do
    optarg=$(expr "x${arg}" : 'x[^=]*=\(.*\)')
    case ${arg} in
    "root=/dev/$parent"p*)
        exit 0
        ;;
    esac
done

exit 1
