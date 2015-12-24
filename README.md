![My image](https://github.com/UiharuKazari2008/TapeMaster/blob/master/img/TapeMaster.jpg)
# TapeMaster
TapeMaster is a automated script that can be used to automate in the mastering of DAT (Digital Audio Tape) and MiniDisc

## What it does
1. It copy's all files that are on a transfer drive
2. Create silence for tape header
3. Plays all audio files that were given on transfer drive in order of the filenames
4. Creates the silence needed to trigger the auto StartID system on a DAT recorder
5. Changes LED status to indicate what it is doing

## Prerequisites
1. SOX to be installed (for 'play' command)
2. for MP3 playback you need 'libsox-fmt-all' installed
3. Good Soundcard / DAC
4. Console to control it
5. Something to do while its recording

## My Setup
I am using a RaspberryPi running Debian with a 8GB Class 6 SD Card, I use a automated program that will keep it connected to my home wifi or my hotspot when im on the go or at work.
Becuase the internal audio out is complete 8bit garbage, Im using my favorite DAC (Turtle Beach Micro II) as it has both Optical and Analog
![My image](https://github.com/UiharuKazari2008/TapeMaster/blob/master/img/mytm.jpg)

To record my tapes i am using my Sony TCD-D8 DAT Recorder as its the only one i have that works all the time. I typicaly use 120 min BASF tapes as i have a big box of them. 
![My image](https://github.com/UiharuKazari2008/TapeMaster/blob/master/img/myplayer.jpg)

To power both of them i am using a 12000mAh powerbank for the TapeMaster and a 22000mAh powerbank for my DAT player. I do not use the same powerbank becuase having a common ground is causeing all sorts of noise. A USB isolator may help.

To control it i use my old Sony Reader with a VNC viewer.