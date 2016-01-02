loop="true"
echo '= TapeMaster SIRCS CLI v1.2 ==================================================='
echo '(p)lay | (P)ause | (s)top | (<)Rwd | (>)FFwd | (<<)AMS- | (>>)AMS+ | (c)ue'
echo '(r)ec Stdby | (R)ec Now | Vol(+) | Vol(-) | (e)ject | (l)ight | (C)ounter'
echo 'or enter full command, exit'
echo '==============================================================================='
echo ''
while [ $loop = "true" ] ; do
echo -n "COMMAND> "
read cmd
if [ $cmd = "exit" ]; then exit
elif [ $cmd = "p" ]; then irsend SEND_ONCE tape PLAY
elif [ $cmd = "P" ]; then irsend SEND_ONCE tape PAUSE
elif [ $cmd = "s" ]; then irsend SEND_ONCE tape STOP
elif [ $cmd = "<" ]; then irsend SEND_ONCE tape REW
elif [ $cmd = ">" ]; then irsend SEND_ONCE tape FFWD
elif [ $cmd = "+" ]; then irsend SEND_ONCE tape VOL+
elif [ $cmd = "-" ]; then irsend SEND_ONCE tape VOL-
elif [ $cmd = "l" ]; then irsend SEND_ONCE tape LIGHT
elif [ $cmd = "<<" ]; then irsend SEND_ONCE tape AMS-
elif [ $cmd = ">>" ]; then irsend SEND_ONCE tape AMS+
elif [ $cmd = "r" ]; then irsend SEND_ONCE tape REC_STDBY
elif [ $cmd = "R" ]; then irsend SEND_ONCE tape REC_START
elif [ $cmd = "e" ]; then irsend SEND_ONCE tape EJECT
elif [ $cmd = "c" ]; then irsend SEND_ONCE tape CUE
elif [ $cmd = "C" ]; then irsend SEND_ONCE tape COUNTER_MODE
else irsend SEND_ONCE tape ${cmd} 
fi
done
