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

# v0.0.1 (2024-08-19)

- Initial version
