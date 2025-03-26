do_install:append:sysworxx() {
    sed -i \
        's/#Storage=auto/Storage=persistent/' \
        ${D}${sysconfdir}/systemd/journald.conf
}
