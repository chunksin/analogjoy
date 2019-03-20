# analogjoy
Python based analog joystick controller for use with MCP3008 ADC chip

This code sample shows how to create and output a joystick device in python reading inputs from an MCP3008 ADC chip via the SPI interface on a Raspberry Pi. You can also use an Analog Zero pi hat for an easy all in one solution. The example analogdriver.py shown here has been created for driving controls but the inputs can easily be changed to standard analog joystick inputs. The button configuration used here is designed to solve the issue of a toggled gear shifter in MAME that wasn't properly implemented until version 0.151.

The analogmulti.py example reads in configurable variables from myconfig.py, that specifies what mode the script run in:

1 = driver mode, a single controller with X/Y/Z axis and a single button for gear shift
2 = single joystick mode, a single analog stick with X/Y axis and a single button
3 = two joystick mode, two analog joysticks with X/Y axis and a single button each

The file analogmenu.sh is a bash based dialog menu that updates the myconfig.py file based on options chosen
