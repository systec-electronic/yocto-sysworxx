# Wifi and Bluetooth support

Links:

- <https://lairdcp.github.io/guides/linux_docs/1.0/lwb-sona-ifx/sig_lwb_sona_ifx_series_radio_linux_yocto.html>
- <https://github.com/LairdCP/LWB5plus-Tutorials/blob/main/A2DP-test-LWB5p-dongle-iMX8M-Plus-EVK.md>
- <https://github.com/LairdCP/LWB5plus-Tutorials/blob/main/LWBplusDongle-imx8-yocto.md>

## Test Wifi

```sh
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password password
# wlan should now be connected
nmcli device show wlan0
nmcli connection show
```

## Test Bluetooth

```sh
bluetoothctl
power on
discoverable on

# connect with tablet or smartphone
```
