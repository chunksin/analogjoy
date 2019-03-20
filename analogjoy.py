#!/usr/bin/python
# Analog Driving Controller for MAME
# March 2019 - Rich Gregory

import RPi.GPIO as GPIO
import spidev
import time
import os
import uinput

# Function for button press
def button_callback(channel):
	if GPIO.input(23):
	  device.emit(uinput.BTN_JOYSTICK,1)
	else:
	  device.emit(uinput.BTN_JOYSTICK,1)

# Initialise GPIO for button
GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Add interrupt for button pin detection
GPIO.add_event_detect(23, GPIO.BOTH, callback=button_callback, bouncetime=300)

# Open SPI bus
spi = spidev.SpiDev()
spi.open(0,0)
spi.max_speed_hz=1000000

# Function to read SPI data from MCP3008 chip
# Channel must be an integer 0-7
def ReadChannel(channel):
  adc = spi.xfer2([1,(8+channel)<<4,0])
  data = ((adc[1]&3) << 8) + adc[2]
  return data

# Set up uinput virtual device
device=uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.ABS_WHEEL+(0,1023,0,0),
                      uinput.ABS_GAS+(0,1023,0,0),
		      uinput.ABS_BRAKE+(0,1023,0,0)
                      ])


# Set Analog channels for joystick axis
joy_x=0
joy_y=1
joy_z=2

# Main polling loop for analog inputs
while True:
    joy_x_value=ReadChannel(joy_x)
    device.emit(uinput.ABS_WHEEL,joy_x_value,syn=True)
    joy_y_value=ReadChannel(joy_y)
    device.emit(uinput.ABS_GAS,joy_y_value,syn=True)
    joy_z_value=ReadChannel(joy_z)
    device.emit(uinput.ABS_BRAKE,joy_z_value,syn=True)
# Poll interval - set here to 10ms, you can reduce it but keep an eye on your CPU!
    time.sleep(0.010)

except KeyboardInterrupt:
GPIO.cleanup()       # clean up GPIO on CTRL+C exit
GPIO.cleanup()       # clean up GPIO on normal exit
