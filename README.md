# analogjoy
Python based analog joystick controller for use with MCP3008 ADC chip

This code sample shows how to create and output a joystick device in python reading inputs from an MCP3008 ADC chip via the SPI interface on a Raspberry Pi.You can also use an Analog Zero pi hat for an easy all in one solution. The example shown here has been created for driving controls but the inputs can easily be changed to standard analog joystick inputs. The button configuration used here is designed to solve the issue of a toggled gear shifter in MAME that wasn't properly implemented until version 0.151.
