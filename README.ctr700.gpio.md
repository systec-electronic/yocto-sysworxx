# GPIO Peripherals

## Digital outputs

```sh
gpioset 4201000.gpio  22=1  # DO_0 FIXME:
gpioset 4201000.gpio  23=1  # DO_1 FIXME:
gpioset 600000.gpio  51=1  # do_2
gpioset 600000.gpio  52=1  # do_3
gpioset 600000.gpio  57=1  # do_4
gpioset 600000.gpio  58=1  # do_5
gpioset 600000.gpio  59=1  # do_6
gpioset 600000.gpio  60=1  # do_7
gpioset 600000.gpio  61=1  # do_8
gpioset 600000.gpio  17=1  # do_9
gpioset 600000.gpio   1=1  # do_10
gpioset 600000.gpio  26=1  # do_11
gpioset 600000.gpio  19=1  # do_12
gpioset 600000.gpio  20=1  # do_13
gpioset 600000.gpio   3=1  # relay0_en
gpioset 600000.gpio   4=1  # relay1_en

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
gpioset 600000.gpio 5=1
gpioset 600000.gpio 6=1
```

## Digital inputs

```sh
# DI0 .. DI15
gpioget 600000.gpio 31 32 33 34 35 36 37 38 39 40 41 42 45 46 47 48

# or check periodically
while true; do gpioget 600000.gpio 31 32 33 34 35 36 37 38 39 40 41 42 45 46 47 48; sleep 0.2; done

# RUN switch
gpioget 600000.gpio 11

# /BOOT and /CONFIG
gpioget 600000.gpio 12 62
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
