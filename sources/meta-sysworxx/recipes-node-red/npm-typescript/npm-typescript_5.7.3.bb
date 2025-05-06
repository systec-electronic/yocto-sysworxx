# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "TypeScript is a language for application scale JavaScript development"
HOMEPAGE = "https://www.typescriptlang.org/"

# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=55a8748c7d5c7253f3e4bb7402ff04db"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = " \
    npm://registry.npmjs.org/;package=typescript;version=${PV} \
    npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json \
    "
SRC_URI[sha256sum] = "80cfca1254bab8e81d639178e42d6406d856fba6e34cad60d1ab50ee6e5f7ebb"
PROVIDES = "typescript"

S = "${WORKDIR}/npm"

inherit npm

# For usage in other recipies when compiling protobuf files (e.g. by grpcio-tools)
BBCLASSEXTEND = "native nativesdk"

LICENSE:${PN} = "Apache-2.0"
