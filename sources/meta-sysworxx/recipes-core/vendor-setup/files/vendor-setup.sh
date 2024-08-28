#!/bin/bash

################################################################################
# Constants and configuration
################################################################################

set -e

readonly COMMAND=$(basename $0)
readonly SUB_COMMAND=$1

readonly BLK_VENDOR=mmcblk0p1

readonly VENDOR_DEVICE_FILE=/vendor/device

################################################################################
# Helper functions
################################################################################

function remount_ro() {
    mount -o remount,ro /dev/${BLK_VENDOR}
}

function remount_rw() {
    mount -o remount,rw /dev/${BLK_VENDOR}
}

################################################################################
# Sub-commands
################################################################################

function sub_default() {
    echo "Usage: $COMMAND <subcommand> [options]"
    echo "This tool changes vendor-specific meta-data. (/vendor)"
    echo "Use this tool with caution"
    echo
    echo "Subcommands:"
    echo "    vendor             - Set vendor data"
    echo "    serial             - Set the serial number of the device"
    echo "    lickey             - Set the Licence Key of the device"
}

function sub_lickey() {
    local LIC_KEY=$1

    remount_rw

    if ! test -f "$VENDOR_DEVICE_FILE"; then
        while true; do echo; done | sub_vendor
    fi
    sed -i '/^LicKey/d' $VENDOR_DEVICE_FILE
    sed -i "4aLicKey = $LIC_KEY" $VENDOR_DEVICE_FILE

    remount_ro
}

function sub_vendor() {
    local SERIAL
    local LIC_KEY

    source <(fw_printenv -c <(echo "/sys/bus/i2c/devices/0-0050/eeprom 0x0000 0x200"))

    case ${fdt_prefix:-undefined} in
    k3-am623-systec-ctr600)
        model="sysWORXX CTR-600"
        ;;
    k3-am623-systec-ctr800)
        model="sysWORXX CTR-800"
        ;;
    *)
        echo "Device model not found. The device is not properly provisioned!"
        exit 1
        ;;
    esac

    remount_rw

    read -p "License key>   " LIC_KEY

    cat >$VENDOR_DEVICE_FILE <<-EOF
        [Device]
        Vendor=SYS TEC electronic AG
        Model=$model
        Serial=${dev_serial_number:-undefined}
        LicKey=$LIC_KEY

EOF
    sed -i 's/^\s*//g' $VENDOR_DEVICE_FILE

    remount_ro
}

################################################################################
# Main
################################################################################

case $SUB_COMMAND in

"" | "-h" | "--help")
    sub_default
    ;;

*)
    shift
    FUNCTION="sub_${SUB_COMMAND}"
    FUNCTION_EXISTS=$(LC_ALL=C type -t "$FUNCTION" || true)
    if [ "$FUNCTION_EXISTS" = "function" ]; then
        $FUNCTION $@
    else
        echo "Error: '${SUB_COMMAND}' is not a known subcommand." >&2
        echo "       Run '$COMMAND --help' for a list of known subcommands." >&2
        exit 1
    fi
    ;;

esac
