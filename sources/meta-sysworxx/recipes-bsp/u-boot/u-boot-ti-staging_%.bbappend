FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-arch-arm-dts-k3-am625-sk.dts-Reduce-RAM-size-to-1GB.patch \
    file://0002-arch-arm-dts-k3-am625-sk.dts-Disable-GPIO-expander-f.patch \
    file://0003-arch-arm-dts-k3-am625-sk.dts-Enable-CLKOUT0-to-suppl.patch \
    file://0004-board-ti-am62x-Add-sysWORXX-specific-adoptions.patch \
    file://0005-board-ti-am62x-sysworxx.c-Remove-obsolete-daughterbo.patch \
    file://0006-board-ti-am62x-sysworxx.c-Reset-ethernet-phys-during.patch \
    file://0007-board-ti-am62x-sysworxx.env-Load-u-boot-environment-.patch \
    file://0008-board-ti-am62x-sysworxx.c-Remove-obsolete-board-dete.patch \
    file://0009-board-ti-am62x-sysworxx.c-Import-EEPROM-as-part-of-b.patch \
    file://0010-board-ti-am62x-sysworxx.c-Detect-mmcdev-based-on-boo.patch \
    file://0011-board-ti-am62x-sysworxx.env-Select-root-partition-bo.patch \
"
