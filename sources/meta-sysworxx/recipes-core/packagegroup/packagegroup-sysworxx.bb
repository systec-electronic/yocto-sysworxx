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
"

RDEPENDS:packagegroup-sysworxx = "\
    packagegroup-sysworxx-init \
    packagegroup-sysworxx-base \
    packagegroup-sysworxx-benchmark \
    packagegroup-sysworxx-extended \
    packagegroup-sysworxx-debug \
"

RDEPENDS:packagegroup-sysworxx-init = "\
    ${VIRTUAL-RUNTIME_initscripts} \
    ${VIRTUAL-RUNTIME_init_manager} \
    ${VIRTUAL-RUNTIME_login_manager} \
    ${VIRTUAL-RUNTIME_syslog} \
"

RDEPENDS:packagegroup-sysworxx-base = "\
    attr \
    bash \
    bzip2 \
    coreutils \
    cpio \
    cpufrequtils \
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
    ncurses \
    net-tools \
    openssh-sftp \
    openssh-sftp-server \
    parted \
    procps \
    psmisc \
    rng-tools \
    sed \
    tar \
    time \
    tzdata \
    util-linux \
"

RDEPENDS:packagegroup-sysworxx-benchmark = "\
    tinymembench \
    whetstone \
    dhrystone \
    cpuburn-arm \
    fio  \
    lmbench \
    memtester \
"

RDEPENDS:packagegroup-sysworxx-extended = "\
    bash-completion \
    htop \
    openssl \
    vim \
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
