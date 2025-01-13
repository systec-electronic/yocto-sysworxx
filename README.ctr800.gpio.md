# GPIO Peripherals

## Digital outputs

```sh
gpioset -t0 DO_0=1; sleep 0.2; gpioset -t0 DO_0=0
gpioset -t0 DO_1=1; sleep 0.2; gpioset -t0 DO_1=0
gpioset -t0 DO_2=1; sleep 0.2; gpioset -t0 DO_2=0
gpioset -t0 DO_3=1; sleep 0.2; gpioset -t0 DO_3=0
gpioset -t0 DO_4=1; sleep 0.2; gpioset -t0 DO_4=0
gpioset -t0 DO_5=1; sleep 0.2; gpioset -t0 DO_5=0
gpioset -t0 DO_6=1; sleep 0.2; gpioset -t0 DO_6=0
gpioset -t0 DO_7=1; sleep 0.2; gpioset -t0 DO_7=0
gpioset -t0 DO_8=1; sleep 0.2; gpioset -t0 DO_8=0
gpioset -t0 DO_9=1; sleep 0.2; gpioset -t0 DO_9=0
gpioset -t0 DO_10=1; sleep 0.2; gpioset -t0 DO_10=0
gpioset -t0 DO_11=1; sleep 0.2; gpioset -t0 DO_11=0
gpioset -t0 DO_12=1; sleep 0.2; gpioset -t0 DO_12=0
gpioset -t0 DO_13=1; sleep 0.2; gpioset -t0 DO_13=0
gpioset -t0 RELAY0_EN=1; sleep 1; gpioset -t0 RELAY0_EN=0
gpioset -t0 RELAY1_EN=1; sleep 1; gpioset -t0 RELAY1_EN=0

# DO_14_PWM
echo 0 > /sys/class/pwm/pwmchip0/export
echo 400000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 300000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable

# DO_15_PWM
echo 0 > /sys/class/pwm/pwmchip2/export
echo 400000000 > /sys/class/pwm/pwmchip2/pwm0/period
echo 100000000 > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip2/pwm0/enable

# RUN and ERR LED
gpioset -t0 LED_RUN=1; sleep 0.2; gpioset -t0 LED_RUN=0
gpioset -t0 LED_ERR=1; sleep 0.2; gpioset -t0 LED_ERR=0
```

## Digital inputs

```sh
# DI0 .. DI15 == KEY_F1 .. KEY_F16
# RUN switch == KEY_1
evtest /dev/input/by-path/platform-gpio_input-event

# /BOOT and /CONFIG
gpioget "/BOOT" "/CONFIG"
```

## Counter

```sh
cd /sys/bus/counter/devices/counter0/count0

# A/B Encoder
echo 0 > enable
echo "quadrature x4" > function
echo 1 > enable
while true; do cat count; sleep 0.2; done

# Counter (counter DI14, DI15 sets count direction)
echo 0 > enable
echo "pulse-direction" > function
echo 1 > enable
while true; do cat count; sleep 0.2; done
```
