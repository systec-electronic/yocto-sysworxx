# Ethernet LEDs

Setup behavior of PHY status LED.

```sh
phytool write eth1/0x3/25 0x1F04
phytool write eth0/0x1/25 0x1F04
```

## OUTPUT CONTROL REGISTER

- INDEX 25
- Size 16 bits

|Bits  |Description                                                    |Type  |Default
|------|---------------------------------------------------------------|------|-------
|15    |**MDIO Buffer Type** When set to a 0, the MDIO output is       |R/W   |0b
|      |open-drain. When set to a 1, the MDIO output is push-pull      |      |
|14    |**INT Buffer Type** When set to a 0, the INT_N output is       |R/W   |0b
|      |open-drain. When set to a 1, the INT_N output is push-pull.    |      |
|      |Note: If the buffer type is set to open-drain, INT_N is always |      |
|      |active low.                                                    |      |
|13:8  |**LED Buffer Type** When set to a 0, the LED pins are          |R/W   |000000b
|      |open-drain or open-source. When set to a 1, the LED pins are   |      |
|      |push-pull Bit 8 is for LED1, bit 9 for LED2, etc.              |      |
|7     |**PME Polarity** When set to a 0, the PME_N pin is active low. |R/W   |0b
|      |When set to a 1, the PME_N pin is active high                  |      |
|6     |**RESERVED**                                                   |R/W   |\-
|5:0   |**LED Polarity** When set to a 0, the LED pins are active low. |R/W   |Note 1
|      |When set to a 1, the LED pins are active high Bit 0 is for     |NASR  |
|      |LED1, bit 1 is for LED2 etc                                    |      |

Note 1: Set by the inverse of the LEDPOL configuration straps.
