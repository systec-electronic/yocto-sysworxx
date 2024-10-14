# ECUcore-AM62x

## Checking out

After doing the "normal" checkout using `git clone`, please run the following
command to checkout and initialize all git submodules (e.g. sources meta-\*)

```sh
git submodule update --init --recursive --force --checkout
```

## Build image

```sh
cd build/
. conf/setenv
bitbake sysworxx-image-default
```

## Write wic image to SD card

To get a list of available block devices run `lsblk`. Find the correct block
device for SD card and then redirect the output of `lsblk` to the device as
shown below.

```sh
# replace "sdX" with the block device which should be used
sudo ./init_sd.sh /dev/sdX
```

## Install from SD-Card to eMMC

- Boot from SD-Card (DIP-6=Off)
- run `bringup.sh`
- Reboot with DIP-6=On

Now RAUC can be used to install new images.

## Build and Install RAUC bundle

```sh
cd build/
. conf/setenv
bitbake sysworxx-bundle
```

The bundle `build/deploy-ti/images/sysworxx/sysworxx-bundle-sysworxx.raucb` can
then be copied to a running device and be installed with `rauc install`. e.g.

```sh
# on PC:
scp build/deploy-ti/images/sysworxx/sysworxx-bundle-sysworxx.raucb root@device:/tmp
# on sysWORXX device:
rauc install /tmp/sysworxx-bundle-sysworxx.raucb
reboot
```

The device will then reboot and switch to the other boot slot.

## Modifying Linux kernel source

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

## Modifying Linux kernel configuration

```sh
bitbake linux-ti-staging -c menuconfig
bitbake linux-ti-staging -c diffconfig
# and `mv` the generated config fragment to the target layer
```

Hint: This can also be done while the kernel is in _modifying_ state. (see
section above)

## Build a specific devicetree separately

Enter development shell for Linux kernel and build a specific device tree:

```sh
bitbake linux-ti-staging -c devshell
make defconfig
make ti/k3-am623-systec-ctr800-rev0.dtb
```

## Force a specific device tree

Stop in u-boot shell and perform one of the following commands to boot with the
specified device tree.

```sh
setenv findfdt setenv name_fdt ti/k3-am623-systec-ctr-prodtest.dtb; boot
setenv findfdt setenv name_fdt ti/k3-am623-systec-ctr600-rev0.dtb; boot
setenv findfdt setenv name_fdt ti/k3-am623-systec-ctr800-rev0.dtb; boot
setenv findfdt setenv name_fdt ti/k3-am625-systec-pi-rev0.dtb; boot
```

## Links

- [AM62x Starter Kit EVM Quick Start Guide](https://dev.ti.com/tirex/explore/node?node=A__AdoyIZ2jtLBUfHZNVmgFBQ__am62x-devtools__FUz-xrs__LATEST&search=am62x)
- [SK-AM62 Starter Kit User's Guide (Rev. C)](https://www.ti.com/document-viewer/lit/html/spruj40)

## Issues & Open questions

- U-Boot:
  - am62x.env: Do we need to override the `default_device_tree`?
- Linux:
  - fallback pinmux and use it in fallback dts
  - implement and test RS-232 with RTS/CTS and RS-485 support
