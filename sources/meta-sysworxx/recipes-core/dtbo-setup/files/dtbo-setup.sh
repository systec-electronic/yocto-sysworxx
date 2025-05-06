#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 SYS TEC electronic AG <https://www.systec-electronic.com/>

set -e

readonly COMMAND=$(basename $0)
readonly SUB_COMMAND=$1

sub_usage() {
    echo
    echo "Usage: $COMMAND <subcommand> [options]"
    echo
    echo "DTBO setup script. Please ensure that your hardware is compatible and"
    echo "the selected DTBO's do not conflict to avoid hardware damage!"
    echo
    echo "Subcommands:"
    echo "    ls"
    echo "        List all available DTBO"
    echo "    get"
    echo "        Get all enabled DTBO"
    echo "    set <dbto>..."
    echo "        Set active DTBO"
    echo "        - if compatible multiple can be enabled at once"
    echo "        - if no dtbo passed all DTBO will be disabled"
}

sub_ls() {
    echo "Available DTBO:"
    find /boot/dtb/ti/ -name "*.dtbo" -exec basename {} \; | sed 's/^/  /'
}

sub_get() {
    name_overlays=$(fw_printenv name_overlays | sed 's/name_overlays=//g' | sed '/^$/d')
    if [ -n "$name_overlays" ]; then
        echo "Enabled DTBO:"
        echo $name_overlays | tr ' ' '\n' | sed 's#ti/#  #g'
    else
        echo "No DTBO currently enabled"
    fi
}

sub_set() {
    if ! cat /sys/firmware/devicetree/base/compatible | tr '\0' '\n' | grep systec,pi >/dev/null; then
        echo "DTBO not compatible for the device"
    fi

    relative_prefix="ti"
    absolute_prefix="/boot/dtb/${relative_prefix}/"
    name_overlays=""
    for dtbo_name in "$@"; do
        if [ ! -e "${absolute_prefix}/${dtbo_name}" ]; then
            echo "DTBO not available: $dtbo_name"
            exit 1
        fi
        name_overlays="${name_overlays}${relative_prefix}/${dtbo_name} "
    done
    fw_setenv name_overlays "$name_overlays"
}

case $SUB_COMMAND in
"" | "-h" | "--help")
    sub_usage
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
