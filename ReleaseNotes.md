# v1.1.0 (2025-08-14)

- Update to latest TI SDK 11.01.05.03
  - Update to Kernel 6.12
  - Update U-Boot to 2025.01
- Switch to mainline Wifi/Bluetooth driver
- Enable usage of first internal watchdog
  - NOTE: When updating via RAUC this change will not fully apply! The watchdog
    will be activated by systemd but not during the boot process.
    Perform a fully fresh installation of SD card or eMMC to update the U-Boot
    bootloader which enables the watchdog during the boot process.
- Update sysworxx-io to 2.3.0
- Minor corrections and improvements

# v1.0.2 (2025-08-25)

- Fix Ethernet PHY reset in U-Boot after Power-on-Reset

# v1.0.1 (2025-06-05)

- Add sysworxx-image-browser-hmi to CI and remove unnecessary commands

# v1.0.0 (2025-04-30)

- Update to Yocto 5.0 scarthgap
- Move most FEATURE_*'s over to meta-sysworxx for usage in other Yocto setups
- Add RAUC support
  - Clean partition setup for SD card and eMMC
  - Enable `useradd-staticids`
- Add sysWORXX Pi support
  - Add device tree overlay (DTBO) support
  - Add device tree overlay for default pin assignment
  - Add device tree overlay for Industrial Communication HAT
  - Add device tree overlay for Smart Metering HAT
- Add Node-RED
- Add basic graphical and wayland support
- Add `sysworxx-io` with Node-RED nodes and CODESYS connector
- Cleanup documentation
- Lots of minor improvements
- Move Docker `data-root` to `/home/.docker` to make storage driver `overlay2`
  available

# v0.0.1 (2024-08-19)

- Initial version
