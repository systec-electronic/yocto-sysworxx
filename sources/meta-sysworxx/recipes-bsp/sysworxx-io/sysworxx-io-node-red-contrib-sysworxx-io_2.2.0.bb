SUMMARY = "I/O library for accessing basic peripherals (digital/analog I/O's, watchdog, etc) on sysWORXX devices"
HOMEPAGE = "http://www.systec-electronic.com"
LIC_FILES_CHKSUM = " \
    file://../../LICENSE;md5=c51d3eef3be114124d11349ca0d7e117 \
"
LICENSE = "LGPL-3.0-or-later"

inherit npm

DEPENDS = "npm-typescript-native"
RDEPENDS:${PN} += "${PN}"

SRC_URI:append = " \
    git://git@github.com/systec-electronic/sysworxx-io.git;protocol=https;branch=main \
    npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json;dev=1 \
"
SRCREV = "8fd88c8e0a3d22d9d771abe4707fe53c275cf745"
S = "${WORKDIR}/git/Bindings/node-red-contrib-sysworxx-io"

python do_configure:append() {
    import os
    import shutil

    # seems like npmsw-fetcher does not create these automatically
    shutil.rmtree("./node_modules/.bin", ignore_errors=True)
    os.mkdir("./node_modules/.bin")
    os.symlink('../copyfiles/copyfiles', './node_modules/.bin/copyfiles')
}

do_compile() {
    tsc
    npm pack
}

do_install() {
    install -d ${D}${datadir}/sysworxx-io
    install -m 0644 ${B}/node-red-contrib-sysworxx-io-${PV}.tgz ${D}${datadir}/sysworxx-io/node-red-contrib-sysworxx-io-latest.tgz
}

FILES:${PN} = " \
    ${datadir} \
"
