inherit systemd

DEPENDS = "lmsensors libiio"

RDEPENDS:${PN} = "lmsensors libiio"
# Codesys needs sudo on the target to deploy the runtime
RDEPENDS:${PN}-codesys-connector += "${PN} sudo"
RDEPENDS:${PN}-dev += "${PN}"

PACKAGES += "${PN}-codesys-connector"

# Flags are empty, no device specifics necessary
CARGO_BUILD_FLAGS += ""

# patch oe_cargo_build so that libctr700drv.so is built

oe_cargo_build:append() {
    bbnote "${CARGO} build ${CARGO_BUILD_FLAGS} --workspace $@"
    "${CARGO}" build ${CARGO_BUILD_FLAGS} --workspace "$@"
}

# patch cargo_do_install so that:
# - shared objects are installed to /usr/lib/ instead of /usr/lib/rust
# - *.rlib files will not be installed

cargo_do_install() {
    install -d "${D}${libdir}"
    install -m755 "${B}/target/${CARGO_TARGET_SUBDIR}/libctr700drv.so" "${D}${libdir}"
    install -m755 "${B}/target/${CARGO_TARGET_SUBDIR}/libsysworxx_io.so" "${D}${libdir}"
    install -m755 "${B}/target/${CARGO_TARGET_SUBDIR}/libsysworxx_io_js.so" "${D}${libdir}/libsysworxx_io_js.node"

    install -d "${D}${bindir}"
    install -m755 "${B}/target/${CARGO_TARGET_SUBDIR}/iodaemon" "${D}${bindir}"
    install -m755 "${B}/target/${CARGO_TARGET_SUBDIR}/codesys-connector" "${D}${bindir}"

    install -d ${D}${includedir}
    install -m 0644 ${S}/include/sysworxx_io.h ${D}${includedir}
    install -m 0644 ${S}/include/ctr700drv.h ${D}${includedir}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/systemd/iodaemon.service ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/Bindings/Codesys/systemd/codesys-connector.service ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/Bindings/Codesys/systemd/codesys-generate-devdesc-xml.service ${D}${systemd_system_unitdir}
}

FILES:${PN} = " \
    ${libdir}/*.so \
    ${libdir}/libsysworxx_io_js.node \
    ${bindir}/iodaemon \
"

FILES:${PN}-codesys-connector = " \
    ${bindir}/codesys-connector \
    ${systemd_system_unitdir}/codesys-connector.service \
    ${systemd_system_unitdir}/codesys-generate-devdesc-xml.service \
"

SYSTEMD_AUTO_ENABLE:${PN}-codesys-connector = "disable"
SYSTEMD_PACKAGES = "${PN} ${PN}-codesys-connector"

SYSTEMD_SERVICE:${PN} = "iodaemon.service"
SYSTEMD_SERVICE:${PN}-codesys-connector += " \
    codesys-connector.service \
    codesys-generate-devdesc-xml.service \
"

FILES:${PN}-dev = " \
    ${includedir}/*.h \
"