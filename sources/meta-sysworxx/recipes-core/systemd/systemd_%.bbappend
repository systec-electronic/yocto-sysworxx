do_install:append() {
    sed -i \
        's/#Storage=auto/Storage=persistent/' \
        ${D}${sysconfdir}/systemd/journald.conf
}
