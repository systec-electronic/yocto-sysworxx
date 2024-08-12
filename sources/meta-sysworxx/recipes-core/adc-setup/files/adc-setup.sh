#!/bin/bash

set -e

readonly CONFIG=/etc/systec/adc-setup

if ! cat /sys/firmware/devicetree/base/compatible | tr "\0" "\n" | grep -q "systec,ctr800"; then
    exit 0
fi

GPIO_U_AI0=$(cat /sys/kernel/debug/gpio | grep EN_U0 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_U_AI1=$(cat /sys/kernel/debug/gpio | grep EN_U1 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_U_AI2=$(cat /sys/kernel/debug/gpio | grep EN_U2 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_U_AI3=$(cat /sys/kernel/debug/gpio | grep EN_U3 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_I_AI0=$(cat /sys/kernel/debug/gpio | grep EN_I0 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_I_AI1=$(cat /sys/kernel/debug/gpio | grep EN_I1 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_I_AI2=$(cat /sys/kernel/debug/gpio | grep EN_I2 | sed 's/ gpio-\([0-9]\+\).*/\1/g')
GPIO_I_AI3=$(cat /sys/kernel/debug/gpio | grep EN_I3 | sed 's/ gpio-\([0-9]\+\).*/\1/g')

readonly EXPORT=/sys/class/gpio/export
readonly GPIO_PREFIX=/sys/class/gpio/gpio

# Sourcing this file will set variables AI0_MODE ... AI3_MODE
if [ -f $CONFIG ]; then
    . $CONFIG
fi

# Just in case, a value is missing or invalid, fallback to 'voltage'
AI0_MODE=$([ "current" == $AI0_MODE ] && echo "current" || echo "voltage")
AI1_MODE=$([ "current" == $AI1_MODE ] && echo "current" || echo "voltage")
AI2_MODE=$([ "current" == $AI2_MODE ] && echo "current" || echo "voltage")
AI3_MODE=$([ "current" == $AI3_MODE ] && echo "current" || echo "voltage")

# For all GPIO's:
# - export, if not already done
# - set direction to output
# - disable output
for GPIO in $GPIO_U_AI0 $GPIO_U_AI1 $GPIO_U_AI2 $GPIO_U_AI3 $GPIO_I_AI0 \
    $GPIO_I_AI1 $GPIO_I_AI2 $GPIO_I_AI3; do
    [ -d ${GPIO_PREFIX}${GPIO} ] || echo $GPIO >$EXPORT
    echo "out" >${GPIO_PREFIX}${GPIO}/direction
    echo "0" >${GPIO_PREFIX}${GPIO}/value
done

setup_adc() {
    local MODE=$1
    local GPIO_U=$2
    local GPIO_I=$3

    if [ $MODE = "current" ]; then
        echo "0" >${GPIO_PREFIX}${GPIO_U}/value
        echo "1" >${GPIO_PREFIX}${GPIO_I}/value
    else
        echo "1" >${GPIO_PREFIX}${GPIO_U}/value
        echo "0" >${GPIO_PREFIX}${GPIO_I}/value
    fi
}

setup_adc $AI0_MODE $GPIO_U_AI0 $GPIO_I_AI0
setup_adc $AI1_MODE $GPIO_U_AI1 $GPIO_I_AI1
setup_adc $AI2_MODE $GPIO_U_AI2 $GPIO_I_AI2
setup_adc $AI3_MODE $GPIO_U_AI3 $GPIO_I_AI3

echo "Set AI0 mode to ${AI0_MODE}"
echo "Set AI1 mode to ${AI1_MODE}"
echo "Set AI2 mode to ${AI2_MODE}"
echo "Set AI3 mode to ${AI3_MODE}"
