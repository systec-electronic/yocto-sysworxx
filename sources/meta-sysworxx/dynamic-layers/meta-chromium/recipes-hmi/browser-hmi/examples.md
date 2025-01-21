# Browser HMI

To enable Browser HMI service run `systemctl enable --now browser-hmi.service`.

## Show External Web-Site

Show an external Web-Site:

```sh
# Run:
#   systemctl edit browser-hmi.service
[Service]
Environment=HMI_URL="https://example.com"
```

## Show Local Node-RED Dashboard

Enable node-red with `systemctl enable --now node-red.service`. Then create a
flow and add a Dashboard to control/monitor some state.

See: <https://flows.nodered.org/node/node-red-dashboard>

```sh
# Run:
#   systemctl edit browser-hmi.service
[Unit]
Requires=NetworkManager-wait-online.service node-red.service
After=NetworkManager-wait-online.service node-red.service

[Service]
# node-red does not seem to implement SD-notify support, therefore give it some time to startup
ExecStartPre=sleep 10
Environment=HMI_URL="http://127.0.0.1:1880/ui"
```
