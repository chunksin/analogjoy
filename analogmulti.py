#!/usr/bin/python
# Analog Controller for MAME
# Modded to include Driving Controls  and Joysticks
# Uses myconfig.py to store variables
# Variables managed using bash dialog menu analogmenu.sh
# March 2019 - Rich Gregory

import RPi.GPIO as GPIO
import spidev
import time
import os
import uinput
import sys
from myconfig import *

if enabled==0:
  sys.exit()

# Function for toggle shifter button press
def button_callback(channel):
    if GPIO.input(shifterpin):
      device.emit(uinput.BTN_JOYSTICK,1)
      time.sleep(0.1)
      device.emit(uinput.BTN_JOYSTICK,0)
    else:
      device.emit(uinput.BTN_JOYSTICK,1)
      time.sleep(0.1)
      device.emit(uinput.BTN_JOYSTICK,0)

# Initialise GPIO for button
if driver and toggleshift:
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(shifterpin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	# Add interrupt for button pin detection
	GPIO.add_event_detect(shifterpin, GPIO.BOTH, callback=button_callback, bouncetime=300)

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

if mode==1:
	# Set up uinput virtual device and begin polling for input
	device = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.ABS_WHEEL+(0,1023,fuzz,deadzone),
                      uinput.ABS_GAS+(0,1023,fuzz,deadzone),
                      uinput.ABS_BRAKE+(0,1023,fuzz,deadzone)
                      ])
    while True:
       joy_x_value=ReadChannel(joy1_x_channel)
       device.emit(uinput.ABS_WHEEL,joy_x_value,syn=True)
       joy_y_value=ReadChannel(joy1_y_channel)
       device.emit(uinput.ABS_GAS,joy_y_value,syn=True)
       joy_z_value=ReadChannel(joy1_z_channel)
       device.emit(uinput.ABS_BRAKE,joy_z_value,syn=True)
       time.sleep(0.010)

if mode==2:
	# Set up uinput virtual device and begin polling for input
	device = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.ABS_X+(0,1023,fuzz,deadzone),
                      uinput.ABS_Y+(0,1023,fuzz,deadzone)
                      ])
    while True:
       joy1_x_value=ReadChannel(joy1_x_channel)
       device.emit(uinput.ABS_X,joy1_x_value,syn=True)
       joy1_y_value=ReadChannel(joy1_y_channel)
       device.emit(uinput.ABS_Y,joy1_y_value,syn=True)
       time.sleep(0.010)
					  
if mode==3:
	# Set up uinput virtual devices and begin polling for input
	device1 = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.ABS_X+(0,1023,fuzz,deadzone),
                      uinput.ABS_Y+(0,1023,fuzz,deadzone)
                      ])
	device2 = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.ABS_X+(0,1023,fuzz,deadzone),
                      uinput.ABS_Y+(0,1023,fuzz,deadzone)
                      ])
    while True:
       joy1_x_value=ReadChannel(joy1_x_channel)
       device1.emit(uinput.ABS_X,joy1_x_value,syn=True)
       joy1_y_value=ReadChannel(joy1_y_channel)
       device1.emit(uinput.ABS_Y,joy1_y_value,syn=True)
       joy2_x_value=ReadChannel(joy2_x_channel)
       device2.emit(uinput.ABS_X,joy2_x_value,syn=True)
       joy2_y_value=ReadChannel(joy2_y_channel)
       device2.emit(uinput.ABS_Y,joy_y2_value,syn=True)
       time.sleep(0.010)
