#!/bin/bash

set -e

update() {
   local dir=$1
   local syscfg=$2
   local dtsi_name=$3

   sysconfig_cli.sh --script "$dir/$syscfg" -o "$dir"
   mv "$dir/devicetree.dtsi" "$dtsi_name"
}

mkdir -p ./devicetree

#      <SOURCE_DIR> <SYSCFG_NAME>      <DTSI_FILENAME>
update ctr700       ctr700-rev2.syscfg ./devicetree/am62x-systec-ctr700-rev2-pinmux.dtsi

# remove unwanted files
git clean -dfX
