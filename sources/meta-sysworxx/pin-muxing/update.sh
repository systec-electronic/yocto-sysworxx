#!/bin/bash

set -e

script_dir="$(dirname $0)"
echo $script_dir

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

echo mkdir -p "${script_dir}/devicetree"
mkdir -p "${script_dir}/devicetree"

#      <SOURCE_DIR> <SYSCFG_NAME>          <DTSI_FILENAME>
update ${script_dir}/sysworxx-ctr ctr800-pinmux-0.syscfg "${script_dir}/devicetree/k3-am623-systec-ctr800-pinmux-0.dtsi"
update ${script_dir}/sysworxx-ctr ctr600-pinmux-0.syscfg "${script_dir}/devicetree/k3-am623-systec-ctr600-pinmux-0.dtsi"
update ${script_dir}/sysworxx-pi pi-pinmux-0.syscfg "${script_dir}/devicetree/k3-am625-systec-pi-pinmux-0.dtsi"

# remove unwanted files
find ${script_dir} \( -name "*.h" -o -name "*.c" -o -name "*.csv" \) \
   -exec rm -v {} \;
