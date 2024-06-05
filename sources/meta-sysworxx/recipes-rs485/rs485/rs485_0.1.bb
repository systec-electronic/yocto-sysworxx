SUMMARY = "Simple rs485 configuration executable"
SECTION = "rs485"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://rs485.c"
TARGET_CC_ARCH += "${LDFLAGS}"

S = "${WORKDIR}"

do_compile() {
        ${CC} rs485.c -o rs485
}

do_install() {
        install -d ${D}${bindir}
        install -m 0755 rs485 ${D}${bindir}
}