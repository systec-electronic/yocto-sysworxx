# Board Information EEPROM

The SoM contains an EEPROM with very basic board information.

## Examples of others boards

### SK-AM62

```sh
# u-boot:
=> i2c bus
=> i2c dev 0
=> i2c probe
=> i2c md 0x50 0.1
0000: aa 55 33 ee 01 fc 00 10 2e 00 41 4d 36 32 2d 53    .U3.......AM62-S
0010: 4b 45 56 4d 00 00 00 00 00 00 45 33 30 31 31 34    KEVM......E30114
0020: 30 31 45 33 00 00 30 31 30 31 32 34 32 32 00 00    01E3..01012422..
0030: 00 00 00 00 30 37 37 36 11 02 00 10 29 13 c2 00    ....0776....)...
0040: 00 00 70 ff 76 1e a6 ff 00 00 00 00 00 00 00 00    ..p.v...........
```

### Beagleplay

```sh
# u-boot:
=> i2c bus
=> i2c dev 0
=> i2c probe
=> i2c md 0x50 0.1
0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
0000: aa 55 33 ee 01 37 00 10 2e 00 42 45 41 47 4c 45    .U3..7....BEAGLE
0010: 50 4c 41 59 2d 41 30 2d 00 00 30 32 30 30 37 38    PLAY-A0-..020078
0020: 30 31 30 33 30 31 30 31 36 34 30 36 32 33 30 30    0103010164062300
0030: 32 39 33 31 53 53 53 53 11 02 00 60 7d fe ff ff    2931SSSS...`}...
0040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
```

## ECUcore example

The following example is used to write a valid EEPROM configuration. Meanings of
these values may be found in `board/ti/common/board_detect.h`.

```bash
#!/bin/bash

MAGIC="\xAA\x55\x33\xee"

BOARD_ID="\x01\x37\x00"

BOARD_INFO="\x10\x2e\x00"
BOARD_INFO_NAME="sysWORXX-CTR\x00\x00\x00\x00"        # 16
BOARD_INFO_VERSION="\x00\x00"                         # 2
BOARD_INFO_PROC_NUMBER="\x00\x00\x00\x00"             # 4
BOARD_INFO_VARIANT="\x00\x00"                         # 2
BOARD_INFO_PCB_REVISION="\x00\x00"                    # 2
BOARD_INFO_SCHEMATIC_BOM_REVISION="\x00\x00"          # 2
BOARD_INFO_SOFTWARE_REVISION="\x00\x00"               # 2
BOARD_INFO_VENDOR_ID="\x00\x00"                       # 2
BOARD_INFO_BUILD_WEEK="\x00\x00"                      # 2
BOARD_INFO_BUILD_YEAR="\x32\x34"                      # 2
BOARD_INFO_BOARD_4P_NUMBER="\x00\x00\x00\x00\x00\x00" # 6
BOARD_INFO_SERIAL="\x53\x53\x53\x53"                  # 4

EEPROM=""
EEPROM="$EEPROM$MAGIC"
EEPROM="$EEPROM$BOARD_ID"
EEPROM="$EEPROM$BOARD_INFO"
EEPROM="$EEPROM$BOARD_INFO_NAME$BOARD_INFO_VERSION$BOARD_INFO_PROC_NUMBER$BOARD_INFO_VARIANT$BOARD_INFO_PCB_REVISION$BOARD_INFO_SCHEMATIC_BOM_REVISION$BOARD_INFO_SOFTWARE_REVISION$BOARD_INFO_VENDOR_ID$BOARD_INFO_BUILD_WEEK$BOARD_INFO_BUILD_YEAR$BOARD_INFO_BOARD_4P_NUMBER$BOARD_INFO_SERIAL"
EEPROM="$EEPROM\xfe"

printf "$EEPROM"
```
