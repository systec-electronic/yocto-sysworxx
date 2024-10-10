PACKAGE_ARCH = "${MACHINE_ARCH}"
SUMMARY = "Package groups for SYSTEC sysWORXX modules."
PR = "r1"

inherit packagegroup

PACKAGES = "\
    packagegroup-sysworxx \
    packagegroup-sysworxx-init \
    packagegroup-sysworxx-base \
    packagegroup-sysworxx-benchmark \
    packagegroup-sysworxx-extended \
    packagegroup-sysworxx-debug \
    packagegroup-sysworxx-graphical \
    packagegroup-sysworxx-wifi \
"

RDEPENDS:packagegroup-sysworxx = "\
    packagegroup-sysworxx-init \
    packagegroup-sysworxx-base \
    packagegroup-sysworxx-benchmark \
    packagegroup-sysworxx-extended \
    packagegroup-sysworxx-debug \
    packagegroup-sysworxx-graphical \
    packagegroup-sysworxx-wifi \
"

RDEPENDS:packagegroup-sysworxx-init = "\
    ${VIRTUAL-RUNTIME_initscripts} \
    ${VIRTUAL-RUNTIME_init_manager} \
    ${VIRTUAL-RUNTIME_login_manager} \
    ${VIRTUAL-RUNTIME_syslog} \
"

RDEPENDS:packagegroup-sysworxx-base = "\
    adc-setup \
    attr \
    bash \
    bringup \
    bzip2 \
    can-setup \
    coreutils \
    cpio \
    cpufrequtils \
    di-setup \
    e2fsprogs \
    e2fsprogs-resize2fs \
    file \
    findutils \
    gawk \
    grep \
    gzip \
    iperf3 \
    iproute2 \
    kernel-modules \
    less \
    libgpiod \
    libgpiod-tools \
    makedevs \
    mc \
    nano \
    ncurses \
    net-tools \
    openssh-sftp \
    openssh-sftp-server \
    parted \
    phy-lan8830t-setup \
    procps \
    psmisc \
    rauc \
    rng-tools \
    rs485-setup \
    sed \
    systec-version \
    tar \
    time \
    tzdata \
    util-linux \
    usbutils \
    vendor-setup \
"

RDEPENDS:packagegroup-sysworxx-benchmark = "\
    cpuburn-arm \
    dhrystone \
    memtester \
    tinymembench \
    whetstone \
"

# python3-distutils is required by python3-docker-compose

RDEPENDS:packagegroup-sysworxx-extended = "\
    bash-completion \
    docker-moby \
    docker-compose \
    python3-distutils-extra \
    htop \
    mosquitto \
    mosquitto-clients \
    node-red \
    openssl \
    vim \
"

RDEPENDS:packagegroup-sysworxx-graphical = "\
    kms++ \
    fb-test \
    fbv \
"

# TODO: we should probably not install the full vim experience, since this
#       introduces gtk dependencies

RDEPENDS:packagegroup-sysworxx-debug = "\
    can-utils \
    ethtool \
    evtest \
    i2c-tools \
    lsof \
    minicom \
    phytool \
    strace \
    tcpdump \
"

RDEPENDS:packagegroup-sysworxx-wifi = "\
    ca-certificates \
    iw \
    kernel-module-lwb5p-backports-summit \
    lwb5plus-sdio-sa-firmware \
    summit-networkmanager-60 \
    summit-supplicant-60 \
    packagegroup-tools-bluetooth \
    bluez5 \
"
