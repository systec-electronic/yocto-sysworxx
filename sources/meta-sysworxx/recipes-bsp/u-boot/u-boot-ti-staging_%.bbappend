FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://fw_env.config \
    file://0001-arch-arm-dts-k3-am625-sk.dts-Disable-GPIO-expander-f.patch \
    file://0002-arch-arm-dts-k3-am625-sk.dts-Enable-CLKOUT0-to-suppl.patch \
    file://0003-configs-am62x_evm_a53_defconfig-Disable-SD-card-volt.patch \
    file://0004-board-ti-am62x-Add-sysWORXX-specific-adoptions.patch \
    file://0005-board-ti-am62x-sysworxx.c-Reset-ethernet-phys-during.patch \
    file://0006-board-ti-am62x-sysworxx.env-Load-u-boot-environment-.patch \
    file://0007-board-ti-am62x-sysworxx.c-Remove-obsolete-board-dete.patch \
    file://0008-board-ti-am62x-sysworxx.c-Import-EEPROM-as-part-of-b.patch \
    file://0009-board-ti-am62x-sysworxx.c-Detect-mmcdev-based-on-boo.patch \
    file://0010-board-ti-am62x-sysworxx.c-Detect-RAM-size-at-runtime.patch \
    ${@bb.utils.contains('DISTRO_FEATURES', 'rauc', \
        'file://0011-board-ti-am62x-sysworxx.env-Select-root-partition-bo.patch', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'rauc', \
        'file://0012-board-ti-am62x-sysworxx.env-Use-rauc-slots-when-boot.patch', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'rauc', \
        'file://0013-board-ti-am62x-sysworxx.env-Add-quiet-flag-to-kernel.patch', '', d)} \
"

UBOOT_CONFIG_FRAGMENTS:sysworxx = "am625_sysworxx_a53.config"

# We build for multiple machines: sysworxx and sysworxx-k3r5 and a QA check will
# error in case the file is deployed twice. Maybe we should move installing
# fw_env.config to a separate recipe.
do_deploy:prepend:sysworxx-k3r5() {
    rm -f ${WORKDIR}/fw_env.config
}
