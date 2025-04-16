#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 SYS TEC electronic AG <https://www.systec-electronic.com/>

set -e

readonly CONFIG=/etc/systec/di-setup

if ! cat /sys/firmware/devicetree/base/compatible | tr "\0" "\n" | grep -q "systec,ctr800"; then
    exit 0
fi

GPIO_DS0=$(cat /sys/kernel/debug/gpio | grep DS0 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_DS1=$(cat /sys/kernel/debug/gpio | grep DS1 | sed 's/ gpio-\([0-9]\+\).*/\1/g')

readonly EXPORT=/sys/class/gpio/export
readonly GPIO_PREFIX=/sys/class/gpio/gpio

# Sourcing this file will set the variable DI_FILTER
if [ -f $CONFIG ]; then
    . $CONFIG
fi

# In case the configuarion is not set, configure to 1 micro second
DI_FILTER=${DI_FILTER:="10us"}

# For all GPIO's:
# - export, if not already done
# - set direction to output
for GPIO in $GPIO_DS0 $GPIO_DS1; do
    [ -d ${GPIO_PREFIX}${GPIO} ] || echo $GPIO >$EXPORT
    echo "out" >${GPIO_PREFIX}${GPIO}/direction
done

#   "10ms"  (DS0=0, DS1=0)
#   "3.2ms" (DS0=0, DS1=1)
#   "1ms"   (DS0=1, DS1=0)
#   "10us"  (DS0=1, DS1=1)
case ${DI_FILTER} in
"10ms")
    readonly VAL_DS0=0
    readonly VAL_DS1=0
    ;;
"3.2ms")
    readonly VAL_DS0=0
    readonly VAL_DS1=1
    ;;
"1ms")
    readonly VAL_DS0=1
    readonly VAL_DS1=0
    ;;
"10us" | *)
    readonly VAL_DS0=1
    readonly VAL_DS1=1
    ;;
esac

echo ${VAL_DS0} >${GPIO_PREFIX}${GPIO_DS0}/value
echo ${VAL_DS1} >${GPIO_PREFIX}${GPIO_DS1}/value

echo "Setup DI filter to ${DI_FILTER} (${VAL_DS0}/${VAL_DS1})"
