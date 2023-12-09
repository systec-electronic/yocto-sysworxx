FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-arch-arm-dts-k3-am625-sk.dts-Reduce-RAM-size-to-1GB.patch \
    file://0002-arch-arm-dts-k3-am625-sk.dts-Disable-GPIO-expander-f.patch \
    file://0003-arch-arm-dts-k3-am625-sk.dts-Enable-CLKOUT0-to-suppl.patch \
    file://0004-board-ti-am62x-evm.c-Reset-ethernet-phys-during-star.patch \
    file://0005-wip-board-ti-am62x-Add-board-detect-for-sysworxx-ctr.patch \
"
