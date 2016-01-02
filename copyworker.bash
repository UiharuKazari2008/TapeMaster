source /opt/tapemaster/config.txt
source $APPHOME/job.set

cd "${LBF}/TAPES/${setname}" || exit 1
prognum=1
echo "" >> ${LBF}/LIST/ftracklist-${setname}.txt
echo "= LOG FOR COPY =========================================" >> ${LBF}/LIST/ftracklist-${setname}.txt
irsend SEND_ONCE tape PAUSE 
echo "Started tape transport" >> ${LBF}/LIST/ftracklist-${setname}.txt
while [ $(wc -l < ${playlist} || echo 0) != 0 ]; do
echo "################## START REC PROGRAM #[${prognum}] ##################" >> ${LBF}/LIST/ftracklist-${setname}.txt
nice -n -10 play -D -q -b 16 -c 2 -V3 --replay-gain ${REPLAYGAIN} "$(head -1 ${playlist})" gain $GAIN >> ${LBF}/LIST/ftracklist-${setname}.txt
echo "################## END OF PROGRAM ##################" >> ${LBF}/LIST/ftracklist-${setname}.txt
if [ $(wc -l < ${playlist}) != 1 ]; then
sleep 2.5s
irsend SEND_ONCE tape STARTID_WRITE &
echo "Write StartID to Tape" >> ${LBF}/LIST/ftracklist-${setname}.txt
fi
sed -i '1d' ${playlist}
((prognum++))
done
echo ">END OF TAPE<" >> ${LBF}/LIST/ftracklist-${setname}.txt
python ${RedLow} 2> /dev/null
python ${GreenHigh} 2> /dev/null
irsend SEND_ONCE tape LIGHT
