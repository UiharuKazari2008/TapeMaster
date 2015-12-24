####### TapeMaster v2 for DAT and MiniDisc #######

# Transfer Drive Device and mount point
TDDN="/dev/disk/by-label/TM_TRACK"
TDMP="~/TapeMaster/TD"
# Highspeed audio file storage location
# Why? It is highly suggested to NOT read directly off a USB drive
# this can cause short delays when tracks load and can mess up timeing
LBF="~/TapeMaster/LB"
# Where to store temp playlist that is used
playlist="~/TapeMaster/MasterList"

# TrackID silence gap time, In your recorders manual it should say how long
# it must be silent to trigger the auto StartID to be written (normaly 3 Sec
# so like my Panasonic SV-4100 only need 2 Sec, CHECK!!!)
TGS=3s
# Tape header, In the case of DAT it is required to have 2 min of silence to have room
# for the tape to streach over time and to protect the first track. Failure to do this
# will result in currupted audio between the 00:00:00 to 00:02:00 ABS time.
# For MiniDisc you can set this to 0s becuase this does not apply
TPG=2m

# Soundcheck track location / settings (If you are doing manual levels aka Analog)
TTF="~/TapeMaster/testtone-1khz.mp3"
TTO="gain -1"

# LED control / LCD scripts for status lights (if you have them)
## Green H/L (Done/Idle)
GreenHigh="/opt/GPIOctrl/gh.py"
GreenLow="/opt/GPIOctrl/gl.py"
## Yellow H/L (Info/Alarm/Check Console)
YellowHigh="/opt/GPIOctrl/lh.py"
YellowLow="/opt/GPIOctrl/ll.py"
## Red H/L (Rec/Busy)
RedHigh="/opt/GPIOctrl/rh.py"
RedLow="/opt/GPIOctrl/rl.py"
## Setup (Setup GPIO Pins and what ever else)
StatInit="/opt/GPIOctrl/init.py"




# Setup LED's and set them to off and Info
python ${StatInit} 2> /dev/null
python ${RedLow} 2> /dev/null
python ${GreenLow} 2> /dev/null
python ${YellowHigh} 2> /dev/null
clear
echo ""
echo " ====      == =====  |"
echo " =   =    = =   =    |  TapeMaster 2 Express"
echo " =   =   ====   =    |  for DAT"
echo " =   =  =   =   =    |"
echo " ====  =    =   =    |  Lossless Audio Copy System"
echo ""
# Wait for used to press init the copy
echo "Connent the transfer drive that contains the tracks (in order)"
read -p "Press [Enter] to start or press ^C to cancel"
# Mount transfer drive
sudo mount ${TDDN} ${LBF} 2> /dev/null
echo "Please wait for data to copy... (this could take a while)"
cp -v ${TDMP}/*.* ${LBF}
cd ${LBF}
sudo umount -l ${TDMP}
echo "It is now safe to remove the transfer drive!"
echo ""
echo -n "Soundcheck? (y/*) "
read soundcheck
if [ ${soundcheck} = "y" ]; then
python ${YellowLow} 2> /dev/null
python ${RedHigh} 2> /dev/null
play ${TTF} ${TTO}
python ${RedLow} 2> /dev/null
python ${YellowHigh} 2> /dev/null
echo "## Input Setup ##"
else
echo "## Input Setup ##"
fi
echo -n "Enter track gain (dB): "
read gain
echo ""
echo ""
echo " # Check List ######################################"
echo " 1. Check battery power / AC"
echo " 2. Files were named in order"
echo " 3. Input levels look good"
echo " 4. Auto StartID is on"
echo " 5. You are at 00:00:00 ABS and Pgm# [0] or [--]"
echo " 6. You are in REC Standby mode and Tape is ready"
echo " ###################################################"
read -p "Press [ENTER] and (Pause) to start"
python ${YellowLow} 2> /dev/null
python ${RedHigh} 2> /dev/null
ls > playlist
echo ""
echo " ################################"
echo " ######## PRESS REC NOW! ########"
echo " ################################"
echo ""
echo " Writing tape header #################"
sleep ${TPG}
prognum=1
echo ""
while [ $(wc -l < ${playlist} || echo 0) != 0 ]; do
clear
echo ""
echo " = LOSSLESS COPY IN PROGRESS ==========================="
echo "   _________    "
echo "  |DAT      |   Program #: [${prognum}]"
echo "  | ( ) ( ) |   ----------------------------------------"
echo "  |_________|   DO NOT INTERRUPT THE RECORDER/PLAYER!"
echo "   REC>>>>>>    "
echo " ======================================================="
# Play at 16 Bit with Track Regain (FLAC only)
play -D -S -b 16 --replay-gain track "$(head -1 ${playlist})" gain $gain
sleep ${TGS}
sed -i '1d' ${playlist}
((prognum++))
done
python ${RedLow} 2> /dev/null
python ${GreenHigh} 2> /dev/null
echo " = COPY COMPLETE ==========================================="
echo " IF THE TAPE IS STILL MOVING DO NOT STOP RECORDING!!"
echo " Allow tape to completely record to the end stop."
echo " DO NOT DISCONNECT THE AUDIO OUTPUT UNTIL COMPLETE"
echo ""
echo " Dont forget: Save the playlist for this tape!"
echo " ==========================================================="
echo ""
echo " Waiting for everything to stop..."
sleep 10s
echo " Eraseing local track storage..."
rm ${LBF}/*.* -f
echo " All done!"