#!/bin/bash

# Analog Service Menu POC
# A bash dialog based menu system to update an options file myconfig.py
# The options file is used to store variables for use in analogmulti.py
# March 2019 - Rich Gregory

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
BACKTITLE="Analog Config Menu"

SAVEIFS=$IFS
IFS=$'\n'
source ./myconfig.py

menu_update () {
grep -v "$1" ./myconfig.py > ./tmp && echo "$1=$2" >> ./tmp && mv ./tmp ./myconfig.py
}

analog_menu () {

if [ $enabled == "1" ]; then
	enableanalogtext="Enable Analog Support (*)"
	disableanalogtext="Disable Analog Support"
else
	enableanalogtext="Enable Analog Support"
	disableanalogtext="Disable Analog Support (*)"
fi

  while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "$BACKTITLE" \
    --title "Analog Setting Menu" \
    --clear \
    --help-button \
    --cancel-label "Main Menu" \
    --menu "Please select: (*) = current setting" $HEIGHT $WIDTH 6 \
    "1" "$enableanalogtext" \
    "2" "$disableanalogtext" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      return 1
      ;;
    $DIALOG_ESC)
      return 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
	"HELP 1" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option enables analog support using the Analog Zero board" 0 0
      ;;
	"HELP 2" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option disables analog support using the Analog Zero board" 0 0
      ;;
    1 )
      dialog --title "$1" --no-collapse --msgbox "Analog Support Enabled" 0 0
	  enabled="1"
	  menu_update "enabled" "1"
	  return 0
      ;;
    2 )
      dialog --title "$1" --no-collapse --msgbox "Analog Support Disabled" 0 0
	  enabled="0"
	  menu_update "enabled" "0"
	  return 0
      ;;
  esac
done
}

driving_menu () {

if [ $toggleshift == "1" ]; then
	enabletoggletext="Enable Toggle Shifter (*)"
	disabletoggletext="Disable Toggle Shifter"
else
	enabletoggletext="Enable Toggle Shifter"
	disabletoggletext="Disable Toggle Shifter (*)"
fi

  while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "$BACKTITLE" \
    --title "Driving Controls Menu" \
    --clear \
    --help-button \
    --cancel-label "Main Menu" \
    --menu "Please select: (*) = current setting" $HEIGHT $WIDTH 8 \
    "1" "Enable Driving Controls (X/Y/Z-axis)" \
    "2" "$enabletoggletext" \
    "3" "$disabletoggletext" \
    "4" "Configure Shifter GPIO Pin (23 Default)" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      return 1
      ;;
    $DIALOG_ESC)
      return 1
      ;;
  esac
  case $selection in
    0 )
      #clear
      echo "Program terminated."
      ;;
	"HELP 1" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option enables driving controls via the Analog Zero board and creates a 3-axis controller" 0 0
      ;;
	"HELP 2" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option enables the toggle shifter functionality for cabs with a single gear switch" 0 0
      ;;
	"HELP 3" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option disables the toggle shifter functionality for cabs with more than one gear switch" 0 0
      ;;
	"HELP 4" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option allows you to specify the GPIO pin used for the toggle shift button" 0 0
      ;;
    1 )
      dialog --title "$1" --no-collapse --msgbox "Driving Controls Enabled" 0 0
	  mode="1"
	  menu_update "mode" "1"
	  return 0
      ;;
    2 )
      dialog --title "$1" --no-collapse --msgbox "Toggle Shifter Enabled" 0 0
	  toggleshift="1"
	  menu_update "toggleshift" "1"
	  return 0
      ;;
    3 )
      dialog --title "$1" --no-collapse --msgbox "Toggle Shifter Disabled" 0 0
	  toggleshift="0"
	  menu_update "toggleshift" "0"
	  return 0
      ;;
    4 )
      input=$(dialog --stdout --inputbox "Please Enter GPIO Pin Number" 0 0)
	  retval=$?
	  shifterpin=$input
	  menu_update "shifterpin" $input
	  dialog --title "$1" --no-collapse --msgbox "GPIO Pin Updated to $input" 0 0
      return 0
      ;;
  esac
done
}

onejoy_menu () {

  while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "$BACKTITLE" \
    --title "Single Joystick Menu" \
    --clear \
    --help-button \
    --cancel-label "Main Menu" \
    --menu "Please select: (*) = current setting" $HEIGHT $WIDTH 8 \
    "1" "Enable Single Joystick (X/Y-axis)" \
    "2" "Configure X-axis Pin (A0 Default)" \
    "3" "Configure Y-axis Pin (A1 Default)" \
    "4" "Configure P1 Start Pin (16 Default)" \
    "5" "Configure P1 Button 1 Pin (19 Default)" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      return 1
      ;;
    $DIALOG_ESC)
      return 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
	"HELP 1" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will enable a single 2-axis joystick using the Analog Zero board" 0 0
      ;;
	"HELP 2" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the analog pin on the Analog Zero board used for the x-axis" 0 0
      ;;
	"HELP 3" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the analog pin on the Analog Zero board used for the y-axis" 0 0
      ;;
	"HELP 4" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the pin used for player 1 start button" 0 0
      ;;
	"HELP 5" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the pin used for player 1 button 1" 0 0
      ;;
    1 )
      dialog --title "$1" --no-collapse --msgbox "Single Joystick Mode Enabled" 0 0
	  mode="2"
	  menu_update "mode" "2"
	  return 0
      ;;
    2 )
      input=$(dialog --stdout --inputbox "Please Enter X-Axis Pin Number" 0 0)
	  retval=$?
	  joy1_x_channel=$input
	  menu_update "joy1_x_channel" $input
	  dialog --title "$1" --no-collapse --msgbox "X-Axis Pin Updated to $input" 0 0
      return 0
      ;;
    3 )
      input=$(dialog --stdout --inputbox "Please Enter Y-Axis Pin Number" 0 0)
	  retval=$?
	  joy1_y_channel=$input
	  menu_update "joy1_y_channel" $input
	  dialog --title "$1" --no-collapse --msgbox "Y-Axis Pin Updated to $input" 0 0
      return 0
      ;;
    4 )
      input=$(dialog --stdout --inputbox "Please Enter Player 1 Start Pin Number" 0 0)
	  retval=$?
	  p1startpin=$input
	  menu_update "p1startpin" $input
	  dialog --title "$1" --no-collapse --msgbox "Player 1 Start Pin Updated to $input" 0 0
      return 0
      ;;
    5 )
      input=$(dialog --stdout --inputbox "Please Enter Player 1 Button 1 Pin Number" 0 0)
	  retval=$?
	  p1b1pin=$input
	  menu_update "p1b1pin" $input
	  dialog --title "$1" --no-collapse --msgbox "Player 1 Button 1 Pin Updated to $input" 0 0
      return 0
      ;;
  esac
done
}

twojoy_menu () {

  while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "$BACKTITLE" \
    --title "Two Joysticks Menu" \
    --clear \
    --help-button \
    --cancel-label "Main Menu" \
    --menu "Please select: (*) = current setting" $HEIGHT $WIDTH 8 \
    "1" "Enable Two Joysticks (X/Y-axis)" \
    "2" "Configure Joy1 X-axis Pin (A0 Default)" \
    "3" "Configure Joy1 Y-axis Pin (A1 Default)" \
    "4" "Configure Joy2 X-axis Pin (A2 Default)" \
    "5" "Configure Joy2 Y-axis Pin (A3 Default)" \
    "6" "Configure P1 Start Pin (16 Default)" \
    "7" "Configure P1 Button 1 Pin (19 Default)" \
    "8" "Configure P2 Start Pin (20 Default)" \
    "9" "Configure P2 Button 1 Pin (21 Default)" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      return 1
      ;;
    $DIALOG_ESC)
      return 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
	"HELP 1" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will enable two 2-axis joysticks using the Analog Zero board" 0 0
      ;;
	"HELP 2" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the analog pin on the Analog Zero board used for the joystick 1 x-axis" 0 0
      ;;
	"HELP 3" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the analog pin on the Analog Zero board used for the joystick 1 y-axis" 0 0
      ;;
	"HELP 4" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the analog pin on the Analog Zero board used for the joystick 2 x-axis" 0 0
      ;;
	"HELP 5" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the analog pin on the Analog Zero board used for the joystick 2 y-axis" 0 0
      ;;
	"HELP 6" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the pin used for player 1 start button" 0 0
      ;;
	"HELP 7" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the pin used for player 1 button 1" 0 0
      ;;
	"HELP 8" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the pin used for player 2 start button" 0 0
      ;;
	"HELP 9" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option will set the pin used for player 2 button 1" 0 0
      ;;
    1 )
      dialog --title "$1" --no-collapse --msgbox "Two Joystick Mode Enabled" 0 0
	  mode="3"
	  menu_update "mode" "3"
	  return 0
      ;;
    2 )
      input=$(dialog --stdout --inputbox "Please Enter X-Axis Pin Number" 0 0)
	  retval=$?
	  joy1_x_channel=$input
	  menu_update "joy1_x_channel" $input
	  dialog --title "$1" --no-collapse --msgbox "Joy 1 X-Axis Pin Updated to $input" 0 0
      return 0
      ;;
    3 )
      input=$(dialog --stdout --inputbox "Please Enter Y-Axis Pin Number" 0 0)
	  retval=$?
	  joy1_y_channel=$input
	  menu_update "joy1_y_channel" $input
	  dialog --title "$1" --no-collapse --msgbox "Joy 1 Y-Axis Pin Updated to $input" 0 0
      return 0
      ;;
	4 )
      input=$(dialog --stdout --inputbox "Please Enter X-Axis Pin Number" 0 0)
	  retval=$?
	  joy2_x_channel=$input
	  menu_update "joy2_x_channel" $input
	  dialog --title "$1" --no-collapse --msgbox "Joy 2 X-Axis Pin Updated to $input" 0 0
      return 0
      ;;
    5 )
      input=$(dialog --stdout --inputbox "Please Enter Y-Axis Pin Number" 0 0)
	  retval=$?
	  joy2_y_channel=$input
	  menu_update "joy2_y_channel" $input
	  dialog --title "$1" --no-collapse --msgbox "Joy 2 Y-Axis Pin Updated to $input" 0 0
      return 0
      ;;
    6 )
      input=$(dialog --stdout --inputbox "Please Enter Player 1 Start Pin Number" 0 0)
	  retval=$?
	  p1startpin=$input
	  menu_update "p1startpin" $input
	  dialog --title "$1" --no-collapse --msgbox "Player 1 Start Pin Updated to $input" 0 0
      return 0
      ;;
    7 )
      input=$(dialog --stdout --inputbox "Please Enter Player 1 Button 1 Pin Number" 0 0)
	  retval=$?
	  p1b1pin=$input
	  menu_update "p1b1pin" $input
	  dialog --title "$1" --no-collapse --msgbox "Player 1 Button 1 Pin Updated to $input" 0 0
      return 0
      ;;
    8 )
      input=$(dialog --stdout --inputbox "Please Enter Player 2 Start Pin Number" 0 0)
	  retval=$?
	  p2startpin=$input
	  menu_update "p2startpin" $input
	  dialog --title "$1" --no-collapse --msgbox "Player 2 Start Pin Updated to $input" 0 0
      return 0
      ;;
    9 )
      input=$(dialog --stdout --inputbox "Please Enter Player 2 Button 1 Pin Number" 0 0)
	  retval=$?
	  p2b1pin=$input
	  menu_update "p2b1pin" $input
	  dialog --title "$1" --no-collapse --msgbox "Player 2 Button 1 Pin Updated to $input" 0 0
      return 0
      ;;
  esac
done
}

adjust_menu () {

  while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "$BACKTITLE" \
    --title "Adjustments Menu" \
    --clear \
    --help-button \
    --cancel-label "Main Menu" \
    --menu "Please select: (*) = current setting" $HEIGHT $WIDTH 8 \
    "1" "Configure Noise Setting" \
    "2" "Configure Deadzone Setting" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      return 1
      ;;
    $DIALOG_ESC)
      return 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
	"HELP 1" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option configures the noise setting if your inputs are not stable - increase the value to stabilise the readings" 0 0
      ;;
	"HELP 2" )
      #clear
      dialog --title "$1" --no-collapse --msgbox "This option configures the deadzone setting for your controls, the value entered is a percentage of total range" 0 0
      ;;
    1 )
      input=$(dialog --stdout --inputbox "Please Enter Noise Setting" 0 0)
	  retval=$?
	  fuzz=$input
	  menu_update "fuzz" $input
	  dialog --title "$1" --no-collapse --msgbox "Noise Setting Updated to $input" 0 0
      return 0
      ;;
    2 )
      input=$(dialog --stdout --inputbox "Please Enter Deadzone Setting" 0 0)
	  retval=$?
	  deadzone=$input
	  menu_update "deadzone" $input
	  dialog --title "$1" --no-collapse --msgbox "Deadzone Setting Updated to $input" 0 0
      return 0
      ;;
  esac
done
}

# Main Menu	

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "$BACKTITLE" \
    --title "Main Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 5 \
    "1" "Enable/Disable Analog Support" \
    "2" "Driving Controls" \
    "3" "Single Analog Joystick" \
	"4" "Two Analog Joysticks" \
	"5" "Analog Adjustments" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      analog_menu
      ;;
    2 )
      driving_menu
      ;;
    3 )
      onejoy_menu
      ;;
    4 )
      twojoy_menu
      ;;
    5 )
      adjust_menu
      ;;
  esac 
done
