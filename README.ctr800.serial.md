# Serial ports

## RS-232

Setup:

```sh
# on PC
stty -F /dev/ttyUSB0 115200 -echo raw
date > /dev/ttyUSB0
cat /dev/ttyUSB0
# on CTR-800
stty -F /dev/ttyS4 115200 -echo raw
cat /dev/ttyS4
date > /dev/ttyS4
```

- `ttyS4` is SERIAL0 on CTR-800
- `ttyS5` is SERIAL1 on CTR-800
- `ttyS6` is SERIAL2 on CTR-800

### Hardware flow control

WIP

## RS-485

WIP
