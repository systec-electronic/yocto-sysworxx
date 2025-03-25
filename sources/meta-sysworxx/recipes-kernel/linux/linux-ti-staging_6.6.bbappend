PINMUX_DIR = "${THISDIR}/../../pin-muxing/devicetree"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-6.6:${PINMUX_DIR}:"


MOVE = ";subdir=git/arch/arm64/boot/dts/ti"

SRC_URI += " \
    file://dynamic_debug.cfg \
    file://disable_wifi_bt.cfg \
    file://cfg80211.cfg \
    file://ecdh.cfg \
    file://rtc.cfg \
    file://gpio_sysfs.cfg \
    file://overlayfs.cfg \
    file://thermal.cfg \
    file://gpio_aggregator.cfg \
    \
    file://0001-tty-serial-8250-Add-custom-RS232-RS485-mode-switch-v.patch \
    file://0002-tty-serial-8250-Add-quirk-handling-for-some-sysworxx.patch \
    file://0003-drivers-thermal-k3_j72xx_bandgab.c-add-sysfs-support.patch \
    file://0004-drivers-gpio-gpio-aggregator.c-Add-compatible-gpio-a.patch \
    \
    file://k3-am623-systec-ctr600-pinmux-0.dtsi${MOVE} \
    file://k3-am623-systec-ctr800-pinmux-0.dtsi${MOVE} \
    \
    file://k3-am623-systec-fallback.dts${MOVE} \
    \
    file://k3-am623-systec-ctr-common.dtsi${MOVE} \
    file://k3-am623-systec-ctr-prodtest.dts${MOVE} \
    file://k3-am623-systec-ctr600-rev0.dts${MOVE} \
    file://k3-am623-systec-ctr800-rev0.dts${MOVE} \
    \
    file://k3-am625-systec-pi-common.dtsi${MOVE} \
    file://k3-am625-systec-pi-pinmux-0.dtsi${MOVE} \
    file://k3-am625-systec-pi-rev0.dts${MOVE} \
    file://k3-am625-systec-pi-sysworxx-io-gpio.dtso${MOVE} \
    file://k3-am625-systec-sysworxx-pi-hat-smart-metering.dtso${MOVE} \
    file://k3-am625-systec-sysworxx-pi-hat-industrial-communication.dtso${MOVE} \
"

FRAGMENTS_DIR := "${THISDIR}/${PN}-6.6"

KERNEL_CONFIG_FRAGMENTS_WIFI += " \
    ${FRAGMENTS_DIR}/disable_wifi_bt.cfg \
    ${FRAGMENTS_DIR}/cfg80211.cfg \
    ${FRAGMENTS_DIR}/ecdh.cfg \
"
# See README.wifi_bt.md for different sources which need to be taken into
# account:
# `disable_wifi_bt.cfg`: Disables all modules which should be provided by Laird
#                        backports
# `cfg80211.cfg`:        Module needs to be built to avoid compiler issues
#                        (`error: 'struct net_device' has no member named 'ieee80211_ptr'`)
# `ecdh.cfg`:            Hard dependency to support Bluetooth

KERNEL_CONFIG_FRAGMENTS += " \
    ${FRAGMENTS_DIR}/dynamic_debug.cfg \
    ${FRAGMENTS_DIR}/rtc.cfg \
    ${FRAGMENTS_DIR}/gpio_sysfs.cfg \
    ${FRAGMENTS_DIR}/gpio_aggregator.cfg \
    ${FRAGMENTS_DIR}/overlayfs.cfg \
    ${FRAGMENTS_DIR}/thermal.cfg \
    ${KERNEL_CONFIG_FRAGMENTS_WIFI} \
"
