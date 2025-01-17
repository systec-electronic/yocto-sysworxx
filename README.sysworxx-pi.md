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
|    I2C2_SDA (GPIO0_44) | 27  | 28  | I2C2_SCL (GPIO0_43)         |
|    GPIO1_24 (MCAN0_TX) | 29  | 30  | GND                         |
|    GPIO1_25 (MCAN0_RX) | 31  | 32  | GPIO1_9 (PWM1)              |
|        GPIO1_28 (PWM2) | 33  | 34  | GND                         |
| GPIO0_37 (MCASP1_AFSX) | 35  | 36  | GPIO0_41                    |
|                GPIO0_4 | 37  | 38  | GPIO0_34 (MCASP1_AXR0)      |
|                    GND | 39  | 40  | GPIO0_33 (MCASP1_AXR1)      |

The table lists the default function as configured in device tree. Functions
in parentheses are usable as alternative.

### Digital Outputs

```sh
gpioset -t0 GPIO0_35=1; sleep 0.2; gpioset -t0 GPIO0_35=0 # DO_0
gpioset -t0 GPIO0_40=1; sleep 0.2; gpioset -t0 GPIO0_40=0 # DO_1
gpioset -t0 GPIO0_43=1; sleep 0.2; gpioset -t0 GPIO0_43=0 # DO_2
gpioset -t0 GPIO1_9=1;  sleep 0.2; gpioset -t0 GPIO1_9=0  # DO_3
gpioset -t0 GPIO0_41=1; sleep 0.2; gpioset -t0 GPIO0_41=0 # DO_4
```

### Digital Inputs

```sh
# DI_0 == GPIO0_0  == KEY_F1
# DI_1 == GPIO0_1  == KEY_F2
# DI_2 == GPIO0_2  == KEY_F3
# DI_3 == GPIO0_3  == KEY_F4
# DI_4 == GPIO0_44 == KEY_F5
# DI_5 == GPIO1_28 == KEY_F6
# DI_6 == GPIO0_4  == KEY_F7
evtest /dev/input/by-path/platform-gpio_input-event
```

### I2C

```sh
# detect devices connected on each of the respective buses
i2cdetect -y -a -r 2
i2cdetect -y -a -r 3
```

## OIL

- RAM has size of 1 GiB since U-Boot initializes it in this way
