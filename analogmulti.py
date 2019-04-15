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
def shifter_callback(channel):
     device.emit(uinput.BTN_JOYSTICK,1)
     time.sleep(0.1)
     device.emit(uinput.BTN_JOYSTICK,0)

# Function for player 1 start button press
def p1start_callback(channel):
   if GPIO.input(p1b1pin):
     device1.emit(uinput.BTN_START,0)
   else:
     device1.emit(uinput.BTN_START,1)

# Function for player 2 start button press
def p2start_callback(channel):
   if GPIO.input(p2startpin):
     device2.emit(uinput.BTN_START,0)
   else:
     device2.emit(uinput.BTN_START,1)

# Function for player 1 button 1 press
def p1b1_callback(channel):
   if GPIO.input(p1b1pin):
     device1.emit(uinput.BTN_1,0)
   else:
     device1.emit(uinput.BTN_1,1)

# Function for player 2 button 1 press
def p2b1_callback(channel):
   if GPIO.input(p2b1pin):
     device2.emit(uinput.BTN_1,0)
   else:
     device2.emit(uinput.BTN_1,1)

# Initialise GPIO for shifter button
if mode==1 and toggleshift==1:
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(shifterpin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	# Add interrupt for shifter button pin detection
	GPIO.add_event_detect(shifterpin, GPIO.BOTH, callback=shifter_callback, bouncetime=300)

# Initialise GPIO for single joystick buttons
if mode==2 or mode==3:
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(p1startpin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	GPIO.setup(p1b1pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	# Add interrupt for player 1 pin detection
	GPIO.add_event_detect(p1startpin, GPIO.BOTH, callback=p1start_callback, bouncetime=300)
    GPIO.add_event_detect(p1b1pin, GPIO.BOTH, callback=p1b1_callback, bouncetime=300)

# Initialise GPIO for second joystick buttons
if mode==3:
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(p2startpin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	GPIO.setup(p2b1pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
	# Add interrupt for player 2 pin detection
	GPIO.add_event_detect(p2startpin, GPIO.BOTH, callback=p2start_callback, bouncetime=300)
    GPIO.add_event_detect(p2b1pin, GPIO.BOTH, callback=p2b1_callback, bouncetime=300)

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
	device1 = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.BTN_START,
                      uinput.BTN_1,
                      uinput.ABS_X+(0,1023,fuzz,deadzone),
                      uinput.ABS_Y+(0,1023,fuzz,deadzone)
                      ])
    while True:
       joy1_x_value=ReadChannel(joy1_x_channel)
       device1.emit(uinput.ABS_X,joy1_x_value,syn=True)
       joy1_y_value=ReadChannel(joy1_y_channel)
       device1.emit(uinput.ABS_Y,joy1_y_value,syn=True)
       time.sleep(0.010)
					  
if mode==3:
	# Set up uinput virtual devices and begin polling for input
	device1 = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.BTN_START,
                      uinput.BTN_1,
                      uinput.ABS_X+(0,1023,fuzz,deadzone),
                      uinput.ABS_Y+(0,1023,fuzz,deadzone)
                      ])
	device2 = uinput.Device([uinput.BTN_JOYSTICK,
                      uinput.BTN_START,
                      uinput.BTN_1,
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
