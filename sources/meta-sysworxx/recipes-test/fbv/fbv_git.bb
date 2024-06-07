DESCRIPTION = "Install tiny framebuffer viewer."
SUMMARY = "Tiny framebuffer image viewer."
AUTHOR = "SYS TEC electronic AG"
HOMEPAGE = "https://github.com/godspeed1989/fbv"

LICENSE = "GPL2"
LIC_FILES_CHKSUM = "file://COPYING;md5=130f9d9dddfebd2c6ff59165f066e41c"

DEPENDS += "jpeg libpng"

PV = "1.1+git${SRCPV}"
SRC_URI = "git://github.com/godspeed1989/fbv;protocol=https;branch=master"
SRCREV = "57f26fb104ef5a718fc934006408719f929f6811"

S = "${WORKDIR}/git"

do_configure () {
    ./configure
}

do_compile () {
    oe_runmake
}

do_install () {
    install -d "${D}/${bindir}"
    install -m 0755 "${S}/fbv" "${D}/${bindir}"
}

FILES:${PN} = "\
    ${bindir} \
"

RDEPENDS:{PN} += "jpeg libpng"
