#!/bin/bash
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 SYS TEC electronic AG <https://www.systec-electronic.com/>
#
# Build self extracting installer

set -e

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
deploy_dir="${script_dir}/../build/deploy-ti/images/sysworxx"

installer=sysworxx-image-default-emmc-installer.sh

sfx_header="${script_dir}/sfx-header"
tmp_tar_ball="$(mktemp -d)/install.tar.gz"
tmp_system_conf="$(mktemp -d)/system.conf"

echo "Build tarball with install files..."

rm -f ${installer}

sed \
   -e '/^data-directory=/d' \
   -e 's#^device=.*rootfs\.0#device=/dev/mmcblk0p5#' \
   -e 's#^device=.*rootfs\.1#device=/dev/mmcblk0p6#' \
   "${script_dir}/../sources/meta-sysworxx/dynamic-layers/meta-rauc/recipes-core/rauc-conf/files/system.conf" \
   > ${tmp_system_conf}

tar -hczvf "${tmp_tar_ball}" \
   -C "${deploy_dir}" \
   tiboot3-am62x-gp-evm.bin \
   tispl.bin \
   u-boot.img \
   sysworxx-image-default-sysworxx.rootfs.tar.gz \
   -C "$(dirname ${tmp_system_conf})" \
   system.conf \
   -C "${script_dir}" \
   bringup.sh

echo "Build sfx installer '${installer}'..."
echo cat ${sfx_header} "${tmp_tar_ball}" >"${installer}"
cat ${sfx_header} "${tmp_tar_ball}" >"${installer}"
chmod +x "${installer}"
echo "done."

rm -rfv "$(dirname "$tmp_tar_ball")"
rm -rfv "$(dirname "$tmp_system_conf")"
