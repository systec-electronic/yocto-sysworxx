#!/bin/bash

#***************************************************************************#
#                                                                           #
#  SYSTEC electronic AG, D-08468 Heinsdorfergrund, Am Windrad 2             #
#  www.systec-electronic.com                                                #
#                                                                           #
#  File:         build-installer.sh                                         #
#  Description:  Create self extracting Yocto installer                     #
#                including bringup.sh                                       #
#                                                                           #
#***************************************************************************#

set -e

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
deploy_dir="$script_dir/../build/deploy-ti/images/sysworxx"

e_num_prefix="E004481"
git_describe=$(git describe --tags)
installer=${e_num_prefix}-sysworxx-image-default-emmc-installer-${git_describe}.sh

sfx_header="./production-test/sfx-header"
tmp_tar_ball="$(mktemp -d)/install.tar.gz"

echo "Build tarball with install files..."

tar -hczvf "$tmp_tar_ball" \
   -C "$deploy_dir" \
   tiboot3.bin \
   tispl.bin \
   u-boot.img \
   sysworxx-image-default-sysworxx.rootfs.tar.gz \
   -C . \
   bringup.sh

echo "Build sfx installer '$installer'..."
echo cat $sfx_header "$tmp_tar_ball" >"$installer"
cat $sfx_header "$tmp_tar_ball" >"$installer"
chmod +x "$installer"
echo "done."

rm -rv "$(dirname "$tmp_tar_ball")"
