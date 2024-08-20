#!/bin/bash

set -e

update() {
   local dir=$1
   local syscfg=$2
   local dtsi_name=$3

   sysconfig_cli.sh --script "$dir/$syscfg" -o "$dir"
   mv "$dir/devicetree.dtsi" "$dtsi_name"

   # If 'Name' in syscfg contains a '-' the generated device tree will contain
   # invalid labels containing '-'. Since only [0-9a-zA-Z_] is allowed for
   # labels the following command will replace these '-' to '_'.
   # (this only replaces the first occurrence)
   sed -i '/^\t.*-.*:/ s/-/_/' "$dtsi_name"
}

mkdir -p ./devicetree

#      <SOURCE_DIR> <SYSCFG_NAME>          <DTSI_FILENAME>
update sysworxx-ctr ctr800-pinmux-0.syscfg ./devicetree/k3-am623-systec-ctr800-pinmux-0.dtsi
update sysworxx-ctr ctr600-pinmux-0.syscfg ./devicetree/k3-am623-systec-ctr600-pinmux-0.dtsi

# remove unwanted files
git clean -dfX
