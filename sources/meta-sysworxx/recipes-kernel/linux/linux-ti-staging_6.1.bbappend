FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-6.1:"

SRC_URI += " \
    file://lan743x.cfg \
    \
    file://0001-Apply-Micrel-PHY-driver-from-https-github.com-microc.patch \
"
