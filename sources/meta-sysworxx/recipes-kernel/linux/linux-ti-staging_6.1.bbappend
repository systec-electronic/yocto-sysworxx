PINMUX_DIR = "${OEBASE}/pin-muxing/devicetree"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-6.1:${PINMUX_DIR}:"

MOVE = ";subdir=git/arch/arm64/boot/dts/ti"

SRC_URI += " \
    file://dynamic_debug.cfg \
    file://disable_wifi_bt.cfg \
    file://cfg80211.cfg \
    file://ecdh.cfg \
    file://rtc.cfg \
    \
    file://0001-Apply-Micrel-PHY-driver-from-https-github.com-microc.patch \
    \
    file://k3-am623-systec-ctr-common.dtsi${MOVE} \
    file://k3-am623-systec-ctr700-rev2-pinmux.dtsi${MOVE} \
    file://k3-am623-systec-ctr700-rev2.dts${MOVE} \
"

FRAGMENTS_DIR := "${THISDIR}/${PN}-6.1"

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
    ${KERNEL_CONFIG_FRAGMENTS_WIFI} \
"
