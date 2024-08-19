SYSTEMD_AUTO_ENABLE:${PN} = "disable"

# a lot of node-red plugins use node-gyp to build native code
RDEPENDS:${PN} = "\
    packagegroup-core-buildessential \
"
