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

### RS-2323 with hardware flow control

```sh
# on PC
stty -F /dev/ttyUSB0 115200 -echo raw crtscts
date > /dev/ttyUSB0
# on sysWORXX
stty -F /dev/ttyS6 115200 -echo raw crtscts
cat > /dev/ttyS6
# expected behaviour:
# - sending data will block until other side has `cat` running
# - if `cat` is already running the send command will not block
```

## RS-485

### With DEN GPIO mapped to RTS

This requires Driver Enable (DEN) mapped to RTS, e.g. `rts-gpios = <&main_gpio0 63 GPIO_ACTIVE_HIGH>;`

```bash
# on CTR-800
/usr/bin/rs485 /dev/ttyS6
stty -F /dev/ttyS6 115200 -echo raw
cat /dev/ttyS6
date > /dev/ttyS6
# on PC
stty -F /dev/ttyUSB0 115200 -echo raw
date > /dev/ttyUSB0
cat > /dev/ttyUSB0
```
