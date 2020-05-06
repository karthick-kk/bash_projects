#!/usr/bin/env bash
## hold down Escape key to exit

x=`xdotool getmouselocation|awk -F: '{print $2}'|awk '{print$1}'|tr -d ' '`
y=`xdotool getmouselocation|awk -F: '{print $3}'|awk '{print$1}'|tr -d ' '`
while [ 1 ]; do
	 eval $(xdotool getmouselocation --shell)
         echo $Y $Y
	 sleep 0.5
	 xdotool mousemove --sync $(( 0 + $X )) $(( 45 + $Y ));
	 echo "I'm alive"
	 sleep 0.5
         xdotool mousemove --sync $x $y 

         keypress=$(xinput --query-state 17 | grep -c "key\[9\]=down")
         echo $keypress
         if [ "$keypress" == "1"  ]
                 then
                 break
         fi
done
exit 0
