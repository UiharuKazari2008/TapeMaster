indir="$HOME/in"
outdir="$HOME/out"
mkdir -p $outdir

echo '= TapeMaster Tools 5 CLI ==============================='
echo ''
echo -n "Enter Tape Name: "
read tapename

cd ${indir}/${tapename} || exit 1

USAGE(){
echo ''
echo 'Tools: query-time	- Check current time of time'
echo '       query-list	- Check current track order'
echo '       prepare-sound	- Prepare audio for mastering'
echo '       prepare-files	- Set filenames to be TM ready'
echo '       dryrun		- Playback sounds to check quality'
echo '       exit		- Exit TapeMaster Tools and close Tape'
echo''
}
USAGE
qtime()
{	echo '= QUERY ============================================' 
	echo "Current Time: $(soxi -T -d *.*)"
	echo '===================================================='
	echo ''
}
qlist()
{
	soxi -a ${indir}/${tapename}/*.* | grep 'title\|TITLE\|Title' | awk -F "=" '{print $2}' > ${indir}/tracklist-${tapename}.txt
	echo '= QUERY ============================================'
	tnumber=1
	cp ${indir}/tracklist-${tapename}.txt ${indir}/tracklist-${tapename}.tmp
	while [ $(wc -l < ${indir}/tracklist-${tapename}.tmp || echo 0) != 0 ]; do
		echo -n "${tnumber}: "
		echo "$(head -1 ${indir}/tracklist-${tapename}.tmp)"
		sed -i '1d' ${indir}/tracklist-${tapename}.tmp
		((tnumber++))
	done
	echo '===================================================='
	echo ''
}


run=1
while [ $run = 1 ]; do
echo -n 'TOOLS> '
read tool

if [ $tool = 'query-time' ]; then qtime
elif [ $tool = 'query-list' ]; then qlist
elif [ $tool = 'prepare-sound' ]; then

	echo -n '' > ${indir}/inplaylist
	cd ${indir}
	for line in ${tapename}/*.*; do
	file="${line%.*}"
	extention="${line#*.}"
	echo "${file}:${extention}" >> ${indir}/inplaylist
	done
	mkdir -p ${outdir}/${tapename}
	
	echo 'Processing audio using the Kazari method'
	#Remove Silence
	while [ $(wc -l < ${indir}/inplaylist || echo 0) != 0 ]; do
	exten="$(head -1 ${indir}/inplaylist | awk -F : '{print $2}')"
	infile="${indir}/$(head -1 ${indir}/inplaylist | awk -F : '{print $1}').${exten}"
	outfile="${outdir}/$(head -1 ${indir}/inplaylist | awk -F : '{print $1}').flac"
	
	echo -n "Processing [$(head -1 ${indir}/inplaylist | awk -F : '{print $1}')]"
	if [ ${infile#*.} = 'flac' ]; then echo -n '[FLAC]'; metaflac --add-replay-gain ${infile}; echo -n '.'
	elif [ ${infile#*.} = 'mp3' ]; then echo -n '[MPEG]'; mp3gain -t -r -k -r ${infile}; echo -n '.'
	else echo '[UNKNOWN-NORPGFIX]'
	fi
	sox "${infile}" ${indir}/stage1.flac silence 1 0 -80d
	echo -n '.'
	sox stage1.flac ${indir}/stage2.flac reverse
	rm ${indir}/stage1.flac
	echo -n '.'
	sox ${indir}/stage2.flac ${indir}/stage3.flac silence 1 0 -80d
	rm ${indir}/stage2.flac
	echo -n '.'
	sox ${indir}/stage3.flac ${outfile} reverse
	rm ${indir}/stage3.flac
	echo ".OK"
	sed -i '1d' ${indir}/inplaylist
	done
	rm ${indir}/inplaylist

elif [ $tool = 'prepare-files' ]; then
	
	echo ''

elif [ $tool = 'dryrun' ]; then

	play -D -b 16 -c 2 ${indir}/${tapename}/*.*

elif [ $tool = 'exit' ]; then exit
else echo 'Option not found'; USAGE
fi
done