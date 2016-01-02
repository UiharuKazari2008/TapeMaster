![My image](https://github.com/UiharuKazari2008/TapeMaster/blob/master/img/TapeMaster.jpg)
# TapeMaster
TapeMaster is a fully automated mastering system for DAT (Digital Audio Tape) and MiniDisc. (or any media format that does not use direct files and requires realtime copying/mastering)

## What it does
1. Controls the recorder via SIRCS or any other IR codeset
2. Create silence for tape header
3. Plays all audio files that were given on transfer drive in order of the filenames
4. Creates the silence needed to trigger the auto StartID system on a DAT recorder
5. Changes LED status to indicate what it is doing
6. Runs playback as high priority process to prevent buffer under-run / skipping
7. Can transfer files from a flash drive to local storage and push completed track lists to drive

## Prerequisites
1. SOX to be installed (for 'play' command)
2. for MP3 playback you need 'libsox-fmt-all' installed
3. Good Sound card / DAC (It would be smart to use SPDIF to a external D/A)
4. Console to control it
5. Something to do while its recording
6. Required hardware to send IR codes
7. Remote codes to control device (SIRCS you should irrecord in RAW mode)
### Needed for TapeMaster Tools 5
1. mp3gain
2. metaflac
3. sox
### Needed for control
1. LIRC installed and setup
2. Remote recorded and working

## TapeMaster Tools
TapeMaster Tools allows you to process your proposed tapes and have them completely read to be transferred and copied.
1. Total Time Query - Shows total time of all tracks
2. Track list Query - Shows the current track list in the order there named
3. Prepare Audio - Calculates Regain (FLAC/MP3) and removes silence at start and end.
4. Prepare Filenames - Renames files so that they are correctly named and ready for transfer.

## My Setup
I am using a RaspberryPi running Debian with a 8GB Class 6 SD Card and a Sony TCD-D8 DATman
![My image](https://github.com/UiharuKazari2008/TapeMaster/blob/master/img/setup.jpg)
### Audio
Because the internal audio out is complete 8bit garbage, Im using a TurtleBeach Micro II for fiberoptic SPDIF output that connects to a FiiO TAISHAN SPDIF D/A Converter that connects to my Sony TCD-D8 DATman via a FiiO line-out lead.
### Control
I am controlling my DATman via the SIRCS pin (Pin 7) on the Digital I/O port. To transmit i am using LIRC on GPIO 17 with a IR LED (the big red thing). The receive i am using a standard 38kHz IR receiver that i got from RadioShack (I was desperate to get it working that day). The remote codes where recorded in RAW mode because irrecord was not picking up the SIRCS packets correctly. Now I don’t own a D3K system controller nor do i have the RM-D3 remote so via the wayback machine i was able to find a site that provided SIRCS4 and the codeset for TCDD7/8. So i had to dig up a old old DOS laptop and wire up the D9 serial port with a IR LED to transmit the codes. (https://plus.google.com/u/0/+YukimiKazari/photos/photo/6234292689321437986?pid=6234292689321437986&oid=114376906382775126678&authkey=CMbQvsGsovnaDA)
### Power
To power both of them i am using a 12000mAh power bank for the TapeMaster and a 22000mAh power bank for my DAT player, IR receiver, and D/A. I do not use the same power bank because having a common ground is causing all sorts of noise. Thanks to fiberoptic audio out and IR control there completely isolated and noise free!

Mail me if you need any help for want more info Uiharu2008@gmail.com