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
./init_sd.sh /dev/sdX
```

## Modifying Linux kernel source

```sh
devtool modify linux-ti-staging
devtool finish linux-ti-staging ../sources/meta-of-your-choice
```

* `modify` will checkout the kernel sources to the workspace directory. Patches
  of recipes will be applied to the source as git commits.
  * changes to the kernel configuration via fragment files is not supported
* `finish` will format all git commits to patches and copy them to the specified
  output directory.
* After this it may be necessary to check the recipe file's content, since the
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
make ti/k3-am625-sk.dtb
```

## Links

* [AM62x Starter Kit EVM Quick Start Guide](https://dev.ti.com/tirex/explore/node?node=A__AdoyIZ2jtLBUfHZNVmgFBQ__am62x-devtools__FUz-xrs__LATEST&search=am62x)
* [SK-AM62 Starter Kit User's Guide (Rev. C)](https://www.ti.com/document-viewer/lit/html/spruj40)
