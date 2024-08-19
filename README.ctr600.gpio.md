# GPIO Peripherals

## Digital outputs

```sh
gpioset 600000.gpio  19=1  # DO_0
gpioset 600000.gpio  20=1  # DO_1

# DO_2_PWM
echo 0 > /sys/class/pwm/pwmchip0/export
echo 400000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 300000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable

# DO_3_PWM
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
# DI0 .. DI3
gpioget 600000.gpio 45 46 47 48

# or check periodically
while true; do gpioget 600000.gpio 45 46 47 48; sleep 0.2; done

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

# Counter (counter DI2, DI3 sets count direction)
echo 0 > enable
echo "pulse-direction" > function
echo 1 > enable
while true; do cat count; sleep 0.2; done
```
