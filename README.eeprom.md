# Board Information EEPROM

The SoM contains an EEPROM with vendor information stored as an partial u-boot
environment. (via import/export)

## EEPROM data

```sh
setenv eeprom_layout 1
setenv fdt_prefix k3-am623-systec-ctr800
setenv hw_iface_rev 0
env set -f ethaddr  22:22:22:22:22:30
env set -f eth1addr 22:22:22:22:22:32
setenv som_order_no 111111
setenv som_bom_rev  1
setenv som_pcb_num  4123
setenv som_serial_number 123123
setenv dev_order_no 1
setenv dev_bom_rev 1
setenv dev_pcb_num 4234
setenv dev_serial_number 234234
```

## Using EEPROM data

These data can be imported and exported with `eeprom_import` and `eeprom_export`
respectively. `eeprom_import` is performed automatically during boot
(in `bootcmd`). The export is only performed during production. In the field
the EEPROM is write protected.

## Selecting device tree in U-Boot

If either `fdt_prefix` OR `hw_iface_rev` are not set the
`k3-am623-systec-fallback` will be used.

If both variables are set the device tree name will be derived in the following
scheme: `${fdt_prefix}-rev${hw_iface_rev}.dtb`

Example:

```sh
setenv fdt_prefix k3-am623-systec-ctr800
setenv hw_iface_rev 0
# will result in k3-am623-systec-ctr800-rev0.dtb
```
