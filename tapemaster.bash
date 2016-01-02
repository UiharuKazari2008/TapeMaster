source /opt/tapemaster/config.txt

GAIN=0
REPLAYGAIN=track
RECOVERY=0
setname="fail"
JOB="X"
DELETEOC=0
QEJECT=1
CHECKIN=1
INPLACE=0
USAGE()
{
	echo "= TapeMaster 2 Professional for DAT / miniDisc ="
	echo "TM2 is a audio tape mastering system"
	echo ""
	echo "-j Job"
	echo "	What do you want to do?"
	echo "	import - Transfer files from transfer disk to local storage"
	echo "	copy - Run the automated copy proccess"
	echo "	sound - Run a soundcheck to correct input levels"
	echo ""
	echo "-n Tape Name (Required)"
	echo "	The prepared master to be copyed"
	echo ""
	echo "-g Output Gain"
	echo "	Gain to be placed on all tracks in this job"
	echo ""
	echo "-r Replay Gain Source"
	echo "	track - use track regain"
	echo "	album - use album regain"
	echo ""
	echo "-p Tape Header"
	echo "	Default is 2 Min, use Xs or Xm"
	echo ""
	echo "-R Delete when done"
	echo "	Delete the files once the copy is done"
	echo ""
	echo "-I Inplace Copy"
	echo "	Do not rewind the tape, start at current cue"
	echo ""
	echo "-E Do not eject"
	echo "	Do not eject tape when starting, just start copy"
	echo ""
	echo "-Y No user input"
	echo "	Do not wait for [ENTER] key, start when exec"
}

while getopts "j:n:g:r:p:cIREY" opt; do
  case $opt in
	j) JOB=${OPTARG};;
    	n) setname=${OPTARG};;
	g) GAIN=${OPTARG};;
	r) REPLAYGAIN=${OPTARG};;
	p) TPG=$OPTARG;;
	I) INPLACE=1;;
	R) DELETEOC=1;;
	E) QEJECT=0;;
	Y) CHECKIN=0;;
    \?) echo "[PEBKAC] WTF is -$OPTARG?, thats not a accepted option, Abort"; USAGE; exit 1;;
    :) echo "[PEBKAC] -$OPTARG requires an argument, Abort"; USAGE; exit 1;;
  esac
done

if [ $# -lt 1 ]; then USAGE; exit; fi
	
# Setup LED's and set them to off and Info
python ${StatInit} 2> /dev/null
python ${RedLow} 2> /dev/null
python ${GreenLow} 2> /dev/null
python ${YellowHigh} 2> /dev/null
echo ''
echo ''
echo '  ______                 __  ___           __           '
echo ' /_  __/___ _____  ___  /  |/  /___ ______/ /____  _____'
echo '  / / / __ `/ __ \/ _ \/ /|_/ / __ `/ ___/ __/ _ \/ ___/'
echo ' / / / /_/ / /_/ /  __/ /  / / /_/ (__  ) /_/  __/ /    '
echo '/_/  \__,_/ .___/\___/_/  /_/\__,_/____/\__/\___/_/     '
echo '         /_/                                            '
echo ''
echo 'TapeMaster 2 Professional'
echo 'Digital Lossless Audio Copy System for Digital Audio Tape'
echo ''

if [ $JOB = "X" ]; then echo "You did not give a command, ABORT"; exit 1
elif [ $JOB = "import" ]; then
	
	echo '####################################'
	echo '#  ___________ ___       _________ #'
	echo '# | USB Disk  |   | --> |          #'
	echo '# |___________|___| --> | USB Port #'
	echo '#                       |          #'
	echo '####################################'
	read -p "Connect Tranfer Drive and press [Enter] or ^C to abort"
	# Mount transfer drive
	sudo mount ${TDDN} "${TDMP}" 2> /dev/null
	echo ""
	
	echo "Copying new tapes....."
	cp -R -v ${TDMP}/TAPES/ ${LBF}/
	
	echo "Sending lists....."
	cp -v ${LBF}/LIST/*.txt ${TDMP}/LIST/
	echo "Done"
	
	sudo umount -l ${TDMP} 2> /dev/null
	sleep 5s
	echo '####################################'
	echo '#           ___________  _________ #'
	echo '#     <--- | USB Disk  ||          #'
	echo '#     <--- |___________|| USB Port #'
	echo '#                       |          #'
	echo '####################################'
	echo "It is now safe to remove the transfer drive!"
	echo ""
	
elif [ $JOB = "copy" ]; then 
	
	echo -n 'Prepareing devices'
	irsend SEND_ONCE tape LIGHT
	echo -n '.'
	irsend SEND_ONCE tape STOP
	echo -n '.'
	if [ $QEJECT = 1 ]; then 
	irsend SEND_ONCE tape EJECT
	echo -n '.'
	echo "READY"
	echo ''
	echo ' ####### = THINK =============================='
	echo '  # ? #  (*) Check the "Tape Protection" Switch'
	echo '   # #   (*) Playlist Time = Tape Time ??'
	echo '    #    ======================================'
	echo ''
	read -p "Insert Tape and press [ENTER]"
	else
	echo "READY"
	fi

	if [ $INPLACE = 0 ]; then irsend SEND_ONCE tape REW; fi

	cd "${LBF}/TAPES/${setname}" ||  exit 1

	echo "= TapeMaster Final Tracklist =" > ${LBF}/LIST/ftracklist-${setname}.txt
	echo "TOTAL PLAY TIME: ${TPG}m + $(soxi -T -d *.*)($(ls | wc -l) Tracks)" >> ${LBF}/LIST/ftracklist-${setname}.txt
	echo "" >> ${LBF}/LIST/ftracklist-${setname}.txt
	echo "Tracklist:" >> ${LBF}/LIST/ftracklist-${setname}.txt
	soxi -a *.* | grep 'title\|TITLE\|Title' | awk -F "=" '{print $2}' >> ${LBF}/LIST/ftracklist-${setname}.txt
	echo ''
	echo '   ###   = INFO ==============================='
	echo '  # i #  Tracklist is avalible in ../LIST'
	echo '   ###   ======================================'
	echo ''
	
	if [ $CHECKIN = 1 ]; then	
	read -p "READY, Press [ENTER] to copy"
	echo ''
	echo '    #    = WARNING ============================'
	echo '   # #   For safety put system into <HOLD> mode'
	echo '  # ! #  to disable keys on recorder'
	echo ' ####### ======================================'
	echo ''
	else
	echo ''
	echo '    #    = WARNING ============================'
	echo '   # #   For safety put system into <HOLD> mode'
	echo '  # ! #  to disable keys on recorder'
	echo ' ####### ======================================'
	echo ''
	sleep 10s
	fi

	echo -n "Setting up recording"
	irsend SEND_ONCE tape COUNTER_ATIME
	echo -n '.'
	irsend SEND_ONCE tape REC_STDBY
	echo -n '.'
	python ${YellowLow} 2> /dev/null
	python ${RedHigh} 2> /dev/null
	echo -n '.'
	ls > ${playlist}
	echo -n '.'
	irsend SEND_ONCE tape AUTOID_TOGGLE
	echo -n '.'
	irsend SEND_ONCE tape REC_START
	echo '.OK'

	echo -n "Creating Tape Header..."
	sleep ${TPG}
	echo -n '[ADDED]'
	irsend SEND_ONCE tape PAUSE
	echo -n '[WAIT]'
	irsend SEND_ONCE tape AUTOID_TOGGLE
	echo '[READY]'

	echo ''
	echo " = COPY IN PROGRESS ===================================="
	echo "   _________    "
	echo "  |DAT      |   Music is now being copied to tape"
	echo "  | ( ) ( ) |   ----------------------------------------"
	echo "  |_________|   DO NOT INTERRUPT THE RECORDER/PLAYER!"
	echo ""
	echo " ======================================================="
	echo ""

	echo "setname=${setname}" > $APPHOME/job.set
	echo "GAIN=${GAIN}" >> $APPHOME/job.set
	echo "REPLAYGAIN=${REPLAYGAIN}" >> $APPHOME/job.set
	echo "DELETEOC=${DELETEOC}" >> $APPHOME/job.set
	chmod +x $APPHOME/job.set

	nohup bash $APPHOME/copyworker.bash >> $APPHOME/copy.log &

elif [ $JOB = "sound" ]; then 

	echo -n 'Prepareing devices'	
	python ${GreenLow} 2> /dev/null
	echo -n '.'
	python ${YellowLow} 2> /dev/null
	echo -n '.'
	python ${RedHigh} 2> /dev/null
	echo -n '.'
	irsend SEND_ONCE tape LIGHT
	echo -n '.'
	irsend SEND_ONCE tape STOP
	echo -n '.'
	irsend SEND_ONCE tape REC_STDBY
	echo -n '.OK'
	echo 'Playing'
	playit="y"

	while [ $playit = "y" ]; do
	play -s -V1 ${TTF} ${TTO}
	echo -n "Play again? (y/n)"
	read playit

	done

	python ${RedLow} 2> /dev/null
	python ${GreenHigh} 2> /dev/null

elif [ $JOB = "direct" ]; then bash $APPHOME/remote.bash
else exit 1
fi
