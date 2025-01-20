inherit systemd

DEPENDS = "lmsensors libiio"
RDEPENDS:${PN} = "lmsensors libiio"

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
    for tgt in "${B}/target/${CARGO_TARGET_SUBDIR}/"*; do
        case $tgt in
            *.rlib)
                rm "$tgt"
                ;;
            *.so)
                install -d "${D}${libdir}"
                install -m755 "$tgt" "${D}${libdir}"
                have_installed=true
                ;;
            *)
                if [ -f "$tgt" ] && [ -x "$tgt" ]; then
                    install -d "${D}${bindir}"
                    install -m755 "$tgt" "${D}${bindir}"
                    have_installed=true
                fi
                ;;
        esac
    done

    install -d ${D}${includedir}
    install -m 0644 ${S}/include/sysworxx_io.h ${D}${includedir}
    install -m 0644 ${S}/include/ctr700drv.h ${D}${includedir}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/systemd/iodaemon.service ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/Bindings/Codesys/systemd/codesys-connector.service ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/Bindings/Codesys/systemd/codesys-generate-devdesc-xml.service ${D}${systemd_system_unitdir}
}

PACKAGES += "${PN}-codesys-connector"
RDEPENDS:${PN}-codesys-connector += "${PN} sudo"

FILES:${PN} = " \
    ${includedir}/*.h \
    ${libdir}/*.so \
    ${bindir}/iodaemon \
"

# there would be an symlink in this file to the library.
# since the target path of the library has been changed by cargo_do_install (see
# above), we do not want this. Bitbakes QA checker checks symlinks to point to
# valid files.
FILES:${PN}-dev = ""

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
