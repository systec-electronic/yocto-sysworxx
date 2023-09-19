PINMUX_DIR = "${OEBASE}/pin-muxing/devicetree"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-6.1:${PINMUX_DIR}:"

MOVE = ";subdir=git/arch/arm64/boot/dts/ti"

SRC_URI += " \
    file://lan743x.cfg \
    \
    file://0001-Apply-Micrel-PHY-driver-from-https-github.com-microc.patch \
    \
    file://am62x-systec-ctr700-rev2-pinmux.dtsi${MOVE} \
    file://am62x-systec-ctr700-rev2.dts${MOVE} \
"
