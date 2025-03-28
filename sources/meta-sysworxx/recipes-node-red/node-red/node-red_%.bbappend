FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://node-red.service \
    file://node-red-prepare.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = " \
    node-red.service \
    node-red-prepare.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

# a lot of node-red plugins use node-gyp to build native code
RDEPENDS:${PN} = "\
    glibc \
    libgcc \
    packagegroup-core-buildessential \
    nodejs-npm \
    sysworxx-io-node-red-contrib-sysworxx-io \
"

do_install:append() {
    # Service Systemd
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/node-red.service ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/node-red-prepare.service ${D}${systemd_unitdir}/system/

    # Remove tmp files from npm install
    rm -rf ${D}/${libdir}/node_modules/${BPN}/node_modules/bcrypt/build-tmp-napi-v3
    rm -rf ${D}/${libdir}/node_modules/${BPN}/node_modules/bcrypt/node-addon-api
}

FILES:${PN} += "\
    ${systemd_unitdir} \
"

# bcrypt-linux-arm64-gnu comes as pre-compiled package
INSANE_SKIP:${PN} = "already-stripped ldflags"
