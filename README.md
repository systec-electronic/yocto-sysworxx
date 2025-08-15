# Yocto Project for sysWORXX AM62x devices

<!--toc:start-->
- [Yocto Project for sysWORXX AM62x devices](#yocto-project-for-sysworxx-am62x-devices)
  - [Checking out Yocto project and build images](#checking-out-yocto-project-and-build-images)
    - [Build default image and write to SD card](#build-default-image-and-write-to-sd-card)
    - [Build and use the eMMC installer](#build-and-use-the-emmc-installer)
    - [Build and Install RAUC bundle](#build-and-install-rauc-bundle)
    - [Build SDK](#build-sdk)
    - [Browser HMI image](#browser-hmi-image)
      - [Browser-HMI example: Show External Web-Site on normal browser mode](#browser-hmi-example-show-external-web-site-on-normal-browser-mode)
      - [Browser-HMI example: Show Local Node-RED Dashboard](#browser-hmi-example-show-local-node-red-dashboard)
      - [Keyboard input](#keyboard-input)
    - [Modifying Linux kernel source](#modifying-linux-kernel-source)
    - [Modifying Linux kernel configuration](#modifying-linux-kernel-configuration)
    - [Build a specific device-tree from Kernel source](#build-a-specific-device-tree-from-kernel-source)
    - [Force a specific device tree](#force-a-specific-device-tree)
  - [Using Peripherals](#using-peripherals)
    - [Digital Outputs](#digital-outputs)
      - [Digital Outputs - sysWORXX CTR-600](#digital-outputs-sysworxx-ctr-600)
      - [Digital Outputs - sysWORXX CTR-800](#digital-outputs-sysworxx-ctr-800)
      - [sysWORXX Pi Outputs](#sysworxx-pi-outputs)
    - [Digital Inputs](#digital-inputs)
      - [Digital Inputs - sysWORXX CTR-600/800](#digital-inputs-sysworxx-ctr-600800)
      - [Digital Inputs - sysWORXX Pi](#digital-inputs-sysworxx-pi)
    - [A/B Encoder / Counter](#ab-encoder-counter)
    - [Serial interfaces](#serial-interfaces)
      - [RS-232](#rs-232)
      - [RS-232 with hardware flow control](#rs-232-with-hardware-flow-control)
      - [RS-485 with DEN GPIO mapped to RTS](#rs-485-with-den-gpio-mapped-to-rts)
    - [CAN Bus](#can-bus)
    - [sysWORXX Pi 40 Pin Header](#sysworxx-pi-40-pin-header)
      - [Device Tree Overlay (DTBO) setup](#device-tree-overlay-dtbo-setup)
        - [DTBO: GPIO via 40 Pin Header](#dtbo-gpio-via-40-pin-header)
        - [DTBO: sysWORXX Pi HAT – Smart Metering](#dtbo-sysworxx-pi-hat-smart-metering)
        - [DTBO: sysWORXX Pi HAT – Industrial Communication](#dtbo-sysworxx-pi-hat-industrial-communication)
  - [Networking](#networking)
    - [Ethernet](#ethernet)
    - [WiFi and Bluetooth](#wifi-and-bluetooth)
      - [WiFi](#wifi)
      - [Set wireless regulatory domain](#set-wireless-regulatory-domain)
      - [Bluetooth](#bluetooth)
      - [Links for WiFi/Bluetooth driver/firmware](#links-for-wifibluetooth-driverfirmware)
  - [Boot media and partitioning](#boot-media-and-partitioning)
    - [eMMC provisioning](#emmc-provisioning)
  - [Board Information EEPROM](#board-information-eeprom)
    - [Example EEPROM data](#example-eeprom-data)
  - [RTI Watchdog](#rti-watchdog)
    - [Test watchdog](#test-watchdog)
    - [Configure Software Watchdog for systemd services](#configure-software-watchdog-for-systemd-services)
    - [Other watchdog peripherals](#other-watchdog-peripherals)
<!--toc:end-->

## Checking out Yocto project and build images

After doing the "normal" checkout using `git clone`, please run the following
command to checkout and initialize all git submodules (e.g. `sources/meta-*`)

```sh
git submodule update --init --recursive --force --checkout
```

### Build default image and write to SD card

Build the image:

```sh
cd build/
. conf/setenv
bitbake sysworxx-image-default
```

To get a list of available block devices run `lsblk`. Find the correct block
device for SD card and then redirect the output of `lsblk` to the device as
shown below.

```sh
# replace "sdX" with the block device which should be used
xzcat build/deploy-ti/images/sysworxx/sysworxx-image-default-sysworxx.rootfs.wic.xz > /dev/sdX
```

### Build and use the eMMC installer

This only applies for sysWORXX devices which have on-board eMMC.

The eMMC installer is a self-extracting archive which can be installed when
booted from SD cards. This will format and partition the eMMC and writes the
default image to it.

```sh
cd build/
. conf/setenv
bitbake sysworxx-image-default
./emmc-installer/build.sh
```

The commands above will create the file `sysworxx-image-default-emmc-installer-*.sh`.
To install it follow the steps below:

- Boot from SD Card
  - sysWORXX CTR-600/800 devices: DIP-6=Off
  - sysWORXX Pi: Boot jumper not connected
- Copy and install

  ```sh
  # On PC: copy from PC zu sysworxx device (example)
  scp sysworxx-image-default-emmc-installer-* root@sysworxx:/tmp
  # On sysworxx:
  chmod +x /tmp/sysworxx-image-default-emmc-installer-*
  /tmp/sysworxx-image-default-emmc-installer-*
  poweroff
  ```

- Unplug power supply, enable eMMC booting and power on again.
  - sysWORXX CTR-600/800 devices: DIP-6=On
  - sysWORXX Pi: Connect boot jumper (`X501`)

### Build and Install RAUC bundle

```sh
cd build/
. conf/setenv
bitbake sysworxx-bundle-default
```

The bundle `build/deploy-ti/images/sysworxx/sysworxx-bundle-default-sysworxx.raucb` can
then be copied to a running device and be installed with `rauc install`. For
example:

```sh
# on PC:
scp build/deploy-ti/images/sysworxx/sysworxx-bundle-default-sysworxx.raucb root@device:/tmp
# on sysWORXX device:
rauc install /tmp/sysworxx-bundle-default-sysworxx.raucb
reboot
```

The device will then reboot and switch to the other boot slot.

### Build SDK

```sh
cd build/
. conf/setenv
bitbake sysworxx-image-default -c populate_sdk
```

The SDK installer script can then be found in:

```
./build/deploy-ti/sdk/sysworxx-glibc-x86_64-sysworxx-image-default-aarch64-sysworxx-toolchain-5.0.4.sh
```

### Browser HMI image

For HMI usage for sysWORXX Pi another image is available:

- Yocto image: `bitbake sysworxx-image-browser-hmi`
- RAUC bundle: `bitbake sysworxx-bundle-browser-hmi`

Resulting files can be installed / updated analog to
`sysworxx-image/bundle-default`.

To enable the `browser-hmi.service` run:

```sh
systemctl enable --now browser-hmi
```

The service has some configuration options for different usage scenarios. Edit
the service with:

```sh
EDITOR=nano systemctl edit browser-hmi.service
# `EDITOR=nano` changes the default editor to `nano`. Users which prefer using
# `vim` can ignore this part.
# In case the terminal emulator over UART produces strange output for TUI
# applications one could try to prepend `TERM=xterm` to fix this.
```

#### Browser-HMI example: Show External Web-Site on normal browser mode

Show an external Web-Site:

```sh
# systemctl edit browser-hmi.service
[Service]
Environment=HMI_URL="https://example.com"
Environment=HMI_ARG3=""
```

#### Browser-HMI example: Show Local Node-RED Dashboard

Enable node-red with `systemctl enable --now node-red.service`. Then create a
flow and add a Dashboard to control/monitor some state.

See: <https://flows.nodered.org/node/node-red-dashboard>

```sh
# systemctl edit browser-hmi.service
[Unit]
Requires=NetworkManager-wait-online.service node-red.service
After=NetworkManager-wait-online.service node-red.service

[Service]
# node-red does not seem to implement SD-notify support, therefore give it some time to startup
ExecStartPre=sleep 10
Environment=HMI_URL="http://127.0.0.1:1880/ui"
```

#### Keyboard input

By default keyboard inputs works with the (English) QWERTY layout. To setup a
different keyboard set the following environment variables.

- XKB_DEFAULT_RULES
- XKB_DEFAULT_MODEL
- XKB_DEFAULT_LAYOUT
- XKB_DEFAULT_VARIANT
- XKB_DEFAULT_OPTIONS

For example using a German keyboard with the `nodeadkeys` variant use:

```sh
# systemctl edit browser-hmi.service
[Service]
Environment=HMI_ARG3=""
Environment=XKB_DEFAULT_LAYOUT="de"
Environment=XKB_DEFAULT_VARIANT="nodeadkeys"
```

To list available options use the `localectl` command with the various `--list-*`
options.

See also [Documentation: Cage Configuration](https://github.com/cage-kiosk/cage/wiki/Configuration)

### Modifying Linux kernel source

```sh
devtool modify linux-ti-staging
devtool finish linux-ti-staging ../sources/meta-of-your-choice
```

- `modify` will checkout the kernel sources to the workspace directory. Patches
  of recipes will be applied to the source as git commits.
  - changes to the kernel configuration via fragment files is not supported
- `finish` will format all git commits to patches and copy them to the specified
  output directory.
- After this it may be necessary to check the recipe file's content, since the
  formatting is sometimes a bit awkward.

### Modifying Linux kernel configuration

```sh
bitbake linux-ti-staging -c menuconfig
bitbake linux-ti-staging -c diffconfig
# and `mv` the generated config fragment to the target layer
```

Hint: This can also be done while the kernel is in _modifying_ state. (see
section above)

### Build a specific device-tree from Kernel source

Enter development shell for Linux kernel and build a specific device tree:

```sh
bitbake linux-ti-staging -c devshell
make defconfig
make ti/k3-am623-systec-ctr800-rev0.dtb
```

### Force a specific device tree

Stop in u-boot shell and perform one of the following commands to boot with the
specified device tree.

```sh
setenv findfdt setenv fdtfile ti/k3-am623-systec-ctr-prodtest.dtb; boot
setenv findfdt setenv fdtfile ti/k3-am623-systec-ctr600-rev0.dtb; boot
setenv findfdt setenv fdtfile ti/k3-am623-systec-ctr800-rev0.dtb; boot
setenv findfdt setenv fdtfile ti/k3-am625-systec-pi-rev0.dtb; boot
```

## Using Peripherals

This section describes, how to access the GPIO in the Linux user space,
_without_ using the `sysworxx-io` library.

Available inputs and outputs may vary from device to device. To get some insight
into Pins and their use the following command.

```sh
gpioinfo | less
```

### Digital Outputs

Some devices provide digital outputs via PWM. When setting the duty cycle of PWM
output to 100% this is equivalent to setting the output active.

#### Digital Outputs - sysWORXX CTR-600

```sh
gpioset -t0 DO_0=1; sleep 0.2; gpioset -t0 DO_0=0
gpioset -t0 DO_1=1; sleep 0.2; gpioset -t0 DO_1=0
gpioset -t0 LED_RUN=1; sleep 0.2; gpioset -t0 LED_RUN=0
gpioset -t0 LED_ERR=1; sleep 0.2; gpioset -t0 LED_ERR=0

# DO_2_PWM
echo 0 > /sys/class/pwm/pwmchip0/export
echo 400000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 300000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable

# DO_3_PWM
echo 0 > /sys/class/pwm/pwmchip2/export
echo 400000000 > /sys/class/pwm/pwmchip2/pwm0/period
echo 100000000 > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip2/pwm0/enable
```

#### Digital Outputs - sysWORXX CTR-800

```sh
gpioset -t0 DO_0=1; sleep 0.2; gpioset -t0 DO_0=0
gpioset -t0 DO_1=1; sleep 0.2; gpioset -t0 DO_1=0
gpioset -t0 DO_2=1; sleep 0.2; gpioset -t0 DO_2=0
gpioset -t0 DO_3=1; sleep 0.2; gpioset -t0 DO_3=0
gpioset -t0 DO_4=1; sleep 0.2; gpioset -t0 DO_4=0
gpioset -t0 DO_5=1; sleep 0.2; gpioset -t0 DO_5=0
gpioset -t0 DO_6=1; sleep 0.2; gpioset -t0 DO_6=0
gpioset -t0 DO_7=1; sleep 0.2; gpioset -t0 DO_7=0
gpioset -t0 DO_8=1; sleep 0.2; gpioset -t0 DO_8=0
gpioset -t0 DO_9=1; sleep 0.2; gpioset -t0 DO_9=0
gpioset -t0 DO_10=1; sleep 0.2; gpioset -t0 DO_10=0
gpioset -t0 DO_11=1; sleep 0.2; gpioset -t0 DO_11=0
gpioset -t0 DO_12=1; sleep 0.2; gpioset -t0 DO_12=0
gpioset -t0 DO_13=1; sleep 0.2; gpioset -t0 DO_13=0

# DO_14_PWM
echo 0 > /sys/class/pwm/pwmchip0/export
echo 400000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 300000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable

# DO_15_PWM
echo 0 > /sys/class/pwm/pwmchip2/export
echo 400000000 > /sys/class/pwm/pwmchip2/pwm0/period
echo 100000000 > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip2/pwm0/enable

gpioset -t0 RELAY0_EN=1; sleep 1; gpioset -t0 RELAY0_EN=0
gpioset -t0 RELAY1_EN=1; sleep 1; gpioset -t0 RELAY1_EN=0
gpioset -t0 LED_RUN=1; sleep 0.2; gpioset -t0 LED_RUN=0
gpioset -t0 LED_ERR=1; sleep 0.2; gpioset -t0 LED_ERR=0
```

#### sysWORXX Pi Outputs

sysWORXX Pi by default only has RGB LED outputs. Via device tree overlays (DTBO)
more can be configured. See [](#device-tree-overlay-dtbo-setup).

```sh
gpioset -t0 LED_RD=1 LED_GN=0 LED_BL=0 # red
gpioset -t0 LED_RD=0 LED_GN=1 LED_BL=0 # green
gpioset -t0 LED_RD=0 LED_GN=0 LED_BL=1 # blue
gpioset -t0 LED_RD=0 LED_GN=0 LED_BL=0 # off
```

### Digital Inputs

Most digital inputs are mapped to a `gpio-keys` device which means they are
available as regular input device. State changes of inputs can be observed with
`evtest`.

However this does not make sense for all kinds of inputs. Some are still
available via GPIO character interface.

```sh
gpioinfo | less
```

#### Digital Inputs - sysWORXX CTR-600/800

```sh
# DI0 .. DI15 == KEY_F1 .. KEY_F16
# RUN switch == KEY_1
evtest /dev/input/by-path/platform-gpio_input-event

# /BOOT and /CONFIG
gpioget "/BOOT" "/CONFIG"
```

#### Digital Inputs - sysWORXX Pi

sysWORXX Pi by default only has no inputs. Via device tree overlays (DTB)
more can be configured. See `dtbo-setup`.

### A/B Encoder / Counter

On CTR-600 and CTR-800 one A/B Encoder / Counter is available. This functionality
is available in parallel to _Digital Input_ functionality.

Connection:

- CTR-600: `DI_2 / DI_3`
- CTR-800: `DI_14 / DI_15`

```sh
cd /sys/bus/counter/devices/counter0/count0

# A/B Encoder
echo 0 > enable
echo "quadrature x4" > function
echo 1 > enable
while true; do cat count; sleep 0.2; done

# Counter (counts pulses on first DI channel, second DI channel switches direction)
echo 0 > enable
echo "pulse-direction" > function
echo 1 > enable
while true; do cat count; sleep 0.2; done
```

### Serial interfaces

- `ttyS4` is `SERIAL0` on CTR-800
- `ttyS5` is `SERIAL1` on CTR-800
- `ttyS6` is `SERIAL2` on CTR-800

#### RS-232

Setup:

```sh
# on PC
stty -F /dev/ttyUSB0 115200 -echo raw
date > /dev/ttyUSB0
cat /dev/ttyUSB0
# on sysWORXX device
stty -F /dev/ttyS4 115200 -echo raw
cat /dev/ttyS4
date > /dev/ttyS4
```

#### RS-232 with hardware flow control

```sh
# on PC
stty -F /dev/ttyUSB0 115200 -echo raw crtscts
date > /dev/ttyUSB0
# on sysWORXX device
stty -F /dev/ttyS6 115200 -echo raw crtscts
cat > /dev/ttyS6
# expected behavior:
# - sending data will block until other side has `cat` running
# - if `cat` is already running the send command will not block
```

#### RS-485 with DEN GPIO mapped to RTS

This requires Driver Enable (DEN) mapped to RTS,
e.g. `rts-gpios = <&main_gpio0 63 GPIO_ACTIVE_HIGH>;`

```sh
# on sysWORXX device
/usr/bin/rs485 /dev/ttyS6
stty -F /dev/ttyS6 115200 -echo raw
cat /dev/ttyS6
date > /dev/ttyS6
# on PC
stty -F /dev/ttyUSB0 115200 -echo raw
date > /dev/ttyUSB0
cat > /dev/ttyUSB0
```

### CAN Bus

Example setup of CAN Bus interface:

```sh
ip link set can0 type can bitrate 500000
ip link set can0 up
```

Use `cansend` / `candump` to send and receive CAN messages.

### sysWORXX Pi 40 Pin Header

All pins of the 40 Pin Header are unused by default. To allow adding
functionality to these pins without replacing the whole root file system
device tree overlays can be used.

|               Function | Pin | Pin | Default                     |
|-----------------------:|:---:|:---:|:----------------------------|
|                    3V3 |  1  |  2  | 5V0                         |
|    GPIO1_23 (I2C3 SCA) |  3  |  4  | 5V0                         |
|    GPIO1_22 (I2C3 SCL) |  5  |  6  | GND                         |
|                GPIO0_0 |  7  |  8  | GPIO0_72 (UART4_TX)         |
|                    GND |  9  | 10  | GPIO0_71 (UART4_RX)         |
|                GPIO0_1 | 11  | 12  | GPIO0_35 (MCASP1_ACLKX)     |
|                GPIO0_2 | 13  | 14  | GND                         |
|                GPIO0_3 | 15  | 16  | MCU_GPIO0_13 (MCU_MCAN0_TX) |
|                    3V3 | 17  | 18  | MCU_GPIO0_14 (MCU_MCAN0_RX) |
|      GPIO0_9 (SPI1_D0) | 19  | 20  | GND                         |
|     GPIO0_10 (SPI1_D1) | 21  | 22  | GPIO0_40                    |
|     GPIO0_8 (SPI1_CLK) | 23  | 24  | GPIO0_7 (SPI1_CS0)          |
|                    GND | 25  | 26  | GPIO0_13 (SPI1_CS1)         |
|    I2C2_SDA (GPIO0_44) | 27  | 28  | I2C2_SCL (GPIO0_43)         |
|    GPIO1_24 (MCAN0_TX) | 29  | 30  | GND                         |
|    GPIO1_25 (MCAN0_RX) | 31  | 32  | GPIO1_9 (PWM1)              |
|        GPIO1_28 (PWM2) | 33  | 34  | GND                         |
| GPIO0_37 (MCASP1_AFSX) | 35  | 36  | GPIO0_41                    |
|                GPIO0_4 | 37  | 38  | GPIO0_34 (MCASP1_AXR0)      |
|                    GND | 39  | 40  | GPIO0_33 (MCASP1_AXR1)      |

Functions in parentheses are usable as alternative.

#### Device Tree Overlay (DTBO) setup

The script `dtbo-setup` is provided to simplify DTBO configuration. Examples:

```sh
dtbo-setup --help
dtbo-setup ls
dtbo-setup set k3-am625-systec-pi-sysworxx-io-default.dtbo
dtbo-setup get
```

Applying device tree overlays is performed by the _u-boot_ bootloader. The DTBO
configuration is saved in _u-boot environment_. Therefore a `reboot` is needed to
apply the new device tree overlay setting.

The environment lives in the second partition (`mmcblk#p2`) on the respective boot device.
This partition is mounted and the environment is available under:
`/boot/u-boot/uboot.env`

##### DTBO: GPIO via 40 Pin Header

Enable with: `dtbo-setup set k3-am625-systec-pi-sysworxx-io-default.dtbo`

This will enable:

- SPI1 with CS0
- UART4
- I2C3
- GPIOs as described below

Outputs:

```sh
gpioset -t0 DO_0=1; sleep 0.2; gpioset -t0 DO_0=0  # GPIO0_1
gpioset -t0 DO_1=1; sleep 0.2; gpioset -t0 DO_1=0  # GPIO0_35
gpioset -t0 DO_2=1; sleep 0.2; gpioset -t0 DO_2=0  # GPIO0_3
gpioset -t0 DO_3=1; sleep 0.2; gpioset -t0 DO_3=0  # MCU_GPIO0_13
gpioset -t0 DO_4=1; sleep 0.2; gpioset -t0 DO_4=0  # GPIO0_40
gpioset -t0 DO_5=1; sleep 0.2; gpioset -t0 DO_5=0  # GPIO0_41
gpioset -t0 DO_6=1; sleep 0.2; gpioset -t0 DO_6=0  # GPIO0_4
```

Inputs:

```sh
# DI_0 == GPIO0_0  == BTN_TRIGGER_HAPPY1
# DI_1 == GPIO0_2  == BTN_TRIGGER_HAPPY2
# DI_2 == MCU_GPIO0_14  == BTN_TRIGGER_HAPPY3
# DI_3 == GPIO0_13 == BTN_TRIGGER_HAPPY4
# DI_4 == GPIO0_44 == BTN_TRIGGER_HAPPY5
# DI_5 == GPIO0_43 == BTN_TRIGGER_HAPPY6
# DI_6 == GPIO1_24 == BTN_TRIGGER_HAPPY7
# DI_7 == GPIO1_25 == BTN_TRIGGER_HAPPY8
# DI_8 == GPIO1_9  == BTN_TRIGGER_HAPPY9
# DI_9 == GPIO1_28 == BTN_TRIGGER_HAPPY10
# DI_10 == GPIO0_37 == BTN_TRIGGER_HAPPY11
# DI_11 == GPIO0_34 == BTN_TRIGGER_HAPPY12
# DI_12 == GPIO0_33 == BTN_TRIGGER_HAPPY13
evtest /dev/input/by-path/platform-sysworxx-0-io-inputs-event-joystick
```

##### DTBO: sysWORXX Pi HAT – Smart Metering

- RS-485/Modbus RTU: `/dev/ttyS4`
- M-Bus: `/dev/ttyS6`
- S0 input: `/dev/input/by-path/platform-sysworxx-1-smart-metering-hat-inputs-event`

##### DTBO: sysWORXX Pi HAT – Industrial Communication

- NetX SPI interface: `/dev/spidev1.0`
- NetX GPIO character device: `industrial-communication-hat-gp`
- CAN-Bus SocketCAN interface: `can0`
- CAN LED: `/sys/class/leds/mcan0_act`

## Networking

Network Manager is used to configure network interfaces.

Use `nmcli` to show the status of all network connections.

### Ethernet

By default Ethernet interfaces are configured for DHCP.

Example for setting up static IPv4 network connection:

```sh
nmcli con add type ethernet con-name "static-ip" ifname eth1
nmcli con mod static-ip ipv4.addresses 192.168.3.100/24 gw4 192.168.3.1
nmcli con mod static-ip ipv4.method manual
nmcli con mod static-ip connection.autoconnect yes
nmcli con up static-ip ifname eth1
```

### WiFi and Bluetooth

#### WiFi

```sh
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password password
# WiFi should now be connected
nmcli device show wlan0
nmcli connection show
```

#### Set wireless regulatory domain

The regulatory domain is set via a kernel module parameter for `brcmfmac`.

```txt
#/etc/modprobe.d/brcmfmac_regd.conf
options brcmfmac regdomain="ETSI"
```

#### Bluetooth

```sh
bluetoothctl
power on
discoverable on
# connect with tablet or smartphone
```

#### Links for WiFi/Bluetooth driver/firmware

- <https://lairdcp.github.io/guides/linux_docs/1.0/lwb-sona-ifx/sig_lwb_sona_ifx_series_radio_linux_yocto.html>
- <https://github.com/LairdCP/LWB5plus-Tutorials/blob/main/A2DP-test-LWB5p-dongle-iMX8M-Plus-EVK.md>
- <https://github.com/LairdCP/LWB5plus-Tutorials/blob/main/LWBplusDongle-imx8-yocto.md>

## Boot media and partitioning

| Size      | Device    | mountpoint    | usage                                         |
|-----------|-----------|---------------|-----------------------------------------------|
| 4 MiB     | mmcblk#p1 | /boot/vendor  | U-Boot bootloader binaries \[\^1\],           |
|           |           |               | Serial number, license keys, calibration data |
| 4 MiB     | mmcblk#p2 | /boot/u-boot  | U-Boot environment                            |
| \-        | mmcblk#p3 | \-            | Extended MBR partition                        |
| 2.5 GiB   | mmcblk#p5 | /             | root-fs slot `A` (read-only)                  |
| 2.5 GiB   | mmcblk#p6 | /             | root-fs slot `B` (read-only)                  |
| Remaining | mmcblk#p7 | /home \[\^2\] | user data in /home and overlays for           |
|           |           |               | with read-write access.                       |

Where `#` represents the boot media:

- `mmcblk0`: eMMC
- `mmcblk1`: SD card

#### eMMC provisioning

This is only needed for new eMMC - this should already be done on purchased
hardware.

In u-boot run:

```sh
# This needs to be done only once for a new eMMC
# activate boot partitions for booting from them
mmc partconf 0 1 1 1
mmc bootbus 0 2 0 0

# https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1168342/faq-am62x-how-to-check-and-configure-emmc-flash-rst_n-signal-to-support-warm_reset-from-emmc-booting-on-am62x-sk-e2
mmc rst-function 0 1

# Give device a power-on-reset. Some eMMC need this for unknown reasons.
```

See also: [Flash Linux to eMMC](https://dev.ti.com/tirex/explore/node?node=A__AdNWBqCVds4ZSqU9osT1tQ__AM62-ACADEMY__uiYMDcq__LATEST)

## Board Information EEPROM

sysWORXX devices have an on-board EEPROM with vendor information stored as an
partial u-boot environment.

These data are used during bootup to set proper MAC addresses and select the
correct device tree for the device.

> [!WARNING]
> This section is only for reference of programmed data these data should and
> cannot be changed by the customer.

### Example EEPROM data

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
setenv dev_order_no 222222
setenv dev_bom_rev 1
setenv dev_pcb_num 4234
setenv dev_serial_number 234234
```

Not all of the above data are mandatory for all sysWORXX devices.

The device tree name will be derived in the following scheme `${fdt_prefix}-rev${hw_iface_rev}.dtb`.
If either `fdt_prefix` OR `hw_iface_rev` are not set the `k3-am623-systec-fallback.dtb` will be used.

## RTI Watchdog

By default the first RTI watchdog is used as primary watchdog. The timeout is
configured to 30 seconds.

U-Boot initializes and configures the watchdog. It also passes the heartbeat (aka
timeout) setting to the Kernel via cmdline.

The Linux Kernel takes over the watchdog after `initramfs` has completed, since
the Watchdog driver (`rti_wdt`) is compiled to a Kernel Module.

`systemd` is configured to take over triggering of the watchdog when starting.

### Test watchdog

The following command will crash the kernel and after 15-30s the device will
reset.

```sh
echo c > /proc/sysrq-trigger
```

Or kill the init manager (`systemd`).

```sh
# kill `init` PID 1 (Most signals will not work here. SIGSEGV does work.)
kill -SEGV 1
```

### Configure Software Watchdog for systemd services

The following `systemd` service will cause a "hard" reboot since the service will
never service the configured software watchdog.

```sh
# /etc/systemd/system/fail.service
[Unit]
Description=Fail watchdog

[Service]
ExecStart=/bin/bash -c 'sleep 99999999'
Restart=always
StartLimitInterval=3min
StartLimitBurst=3
StartLimitAction=reboot-force
WatchdogSec=3

[Install]
WantedBy=multi-user.target
```

In case the reboot would get stuck the hardware watchdog should still lead to
reset.

See also:

- <https://www.man7.org/linux/man-pages/man5/systemd-system.conf.5.html#HARDWARE_WATCHDOG>
- <https://man7.org/linux/man-pages/man3/sd_notify.3.html>

### Other watchdog peripherals

sysWORXX AM62x devices may have more watchdogs available which can be used
directly from applications. To get a list of available watchdogs use the
following command.

```sh
ls -la /dev/watchdog*
```

To test the functionality and cause a reset run the following command.

```sh
echo 1 > /dev/watchdog3
```

See also: <https://www.kernel.org/doc/html/v5.9/watchdog/watchdog-api.html>
