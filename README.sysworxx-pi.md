# Peripherals

## LED

```sh
# order: r/g/b
gpioset 600000.gpio 12=1 14=0 11=0; sleep 1; \
gpioset 600000.gpio 12=0 14=1 11=0; sleep 1; \
gpioset 600000.gpio 12=0 14=0 11=1; sleep 1; \
gpioset 600000.gpio 12=0 14=0 11=0;
```

## I2C

```sh
# connect some kind of network to get the current time via NTP beforehand
cat /sys/bus/i2c/devices/0-0051/rtc/rtc0/{date,time}
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
|    I2C2_SDA (GPIO0_44) | 27  | 28  | I2C2_SCL (GPIO0_43)         |
|    GPIO1_24 (MCAN0_TX) | 29  | 30  | GND                         |
|    GPIO1_25 (MCAN0_RX) | 31  | 32  | GPIO1_9 (PWM1)              |
|        GPIO1_28 (PWM2) | 33  | 34  | GND                         |
| GPIO0_37 (MCASP1_AFSX) | 35  | 36  | GPIO0_41                    |
|                GPIO0_4 | 37  | 38  | GPIO0_34 (MCASP1_AXR0)      |
|                    GND | 39  | 40  | GPIO0_33 (MCASP1_AXR1)      |

The table lists the default function as configured in device tree. Functions
in parentheses are usable as alternative.

### I2C

```sh
# detect devices connected on each of the respective buses
i2cdetect -y -a -r 2
i2cdetect -y -a -r 3
```

### GPIO

```sh
gpiomon 600000.gpio  0 1 2 3 9 10 8 37 4 72 71 35 40 7 13 41 34 33
gpiomon 601000.gpio  22 23 24 25 28 9
gpiomon 4201000.gpio 13 14
```

## OIL

- Should we keep the JTAG connector at the bottom of the PCB?
- RAM has size of 1 GiB since U-Boot initializes it in this way
