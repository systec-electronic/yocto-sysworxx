# Peripherals

## LED

```sh
# order: r/g/b
gpioset -t0 LED_RD=1 LED_GN=0 LED_BL=0 # red
gpioset -t0 LED_RD=0 LED_GN=1 LED_BL=0 # green
gpioset -t0 LED_RD=0 LED_GN=0 LED_BL=1 # blue
gpioset -t0 LED_RD=0 LED_GN=0 LED_BL=0 # off
```

## I2C

```sh
# connect network to get current time via NTP beforehand
cat /sys/bus/i2c/devices/1-0032/rtc/rtc0/{date,time}
```

## 40 Pin connector

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
|    GPIO0_44 (I2C2_SDA) | 27  | 28  | GPIO0_43 (I2C2_SCL)         |
|    GPIO1_24 (MCAN0_TX) | 29  | 30  | GND                         |
|    GPIO1_25 (MCAN0_RX) | 31  | 32  | GPIO1_9 (PWM1)              |
|        GPIO1_28 (PWM2) | 33  | 34  | GND                         |
| GPIO0_37 (MCASP1_AFSX) | 35  | 36  | GPIO0_41                    |
|                GPIO0_4 | 37  | 38  | GPIO0_34 (MCASP1_AXR0)      |
|                    GND | 39  | 40  | GPIO0_33 (MCASP1_AXR1)      |

## Device tree overlays

```sh
dtbo-setup set k3-am625-systec-pi-sysworxx-io-gpio.dtbo
reboot

# get all options with:
dtbo-setup --help
```

### Digital Outputs

```sh
gpioset -t0 DO0=1; sleep 0.2; gpioset -t0 DO0=0
gpioset -t0 DO1=1; sleep 0.2; gpioset -t0 DO1=0
gpioset -t0 DO2=1; sleep 0.2; gpioset -t0 DO2=0
gpioset -t0 DO3=1; sleep 0.2; gpioset -t0 DO3=0
gpioset -t0 DO4=1; sleep 0.2; gpioset -t0 DO4=0
```

### Digital Inputs

```sh
# DI0 == GPIO0_0  == BTN_TRIGGER_HAPPY1
# DI1 == GPIO0_1  == BTN_TRIGGER_HAPPY2
# DI2 == GPIO0_2  == BTN_TRIGGER_HAPPY3
# DI3 == GPIO0_3  == BTN_TRIGGER_HAPPY4
# DI4 == GPIO0_44 == BTN_TRIGGER_HAPPY5
# DI5 == GPIO1_28 == BTN_TRIGGER_HAPPY6
# DI6 == GPIO1_9  == BTN_TRIGGER_HAPPY7
evtest /dev/input/by-path/platform-sysworxx-0-io-inputs-event-joystick
```
