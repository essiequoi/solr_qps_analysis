#! /bin/bash
#accepted value 79113
#experimental value 79138
#percent error .0316

#HOUR=18
#MINUTE=20
#LOG=10_05
LOG_FILE=$LOG.log

#PEAK HOUR ANALYSIS
#start_time='00:*:*'
#end_time='01:*:*'

#PEAK MINUTE ANALYSIS
#start_time=$HOUR':00:*'
#end_time=$HOUR':01:*'

#PEAK SECOND ANALYSIS
start_time=$HOUR':'$MINUTE':00'
end_time=$HOUR':'$MINUTE':01'

ANALYSIS=SECOND
GRANULARITY=seconds
OUTPUT_FILE=$GRANULARITY'_2_'$LOG'.txt'


#echo 'PEAK HOUR IS' $HOUR 'to' $((10#$HOUR + 1))
echo 'PEAK MINUTE IS' $MINUTE 'to' $((10#$MINUTE + 1))

increment_hour(){
	#identify the digits which represent hour,minutes,seconds
	start_hour=${start_time:0:2}
	end_hour=${end_time:0:2}
	#add one hour,second,minute
	start_plus_one=$((10#$start_hour + 1))
	end_plus_one=$((10#$end_hour + 1))

	#if sum of above is just one digit, prepend a '0'
	if [ ${#start_plus_one} == 1 ]
	then
		new_start_time='0'$start_plus_one':0*:*'
	else
		new_start_time=$start_plus_one':0*:*'
	fi
	
	if [ ${#end_plus_one} == 1 ]
	then
		new_end_time='0'$end_plus_one':0*:*'
	else
		new_end_time=$end_plus_one':0*:*'
	fi
	
	start_time=$new_start_time
	end_time=$new_end_time
	echo $new_start_time ' ' $new_end_time
}


increment_minute(){
	#identify the digits which represent hour,minutes,seconds
	start_minute=${start_time:3:2}
	end_minute=${end_time:3:2}
	#add one hour,second,minute
	start_plus_one=$((10#$start_minute + 1))
	end_plus_one=$((10#$end_minute + 1))

	#if sum of above is just one digit, prepend a '0'
	if [ ${#start_plus_one} == 1 ]
	then
		new_start_time=$HOUR':0'$start_plus_one':*'
	else
		new_start_time=$HOUR':'$start_plus_one':*'
	fi
	
	if [ ${#end_plus_one} == 1 ]
	then
		new_end_time=$HOUR':0'$end_plus_one':*'
	else
		new_end_time=$HOUR':'$end_plus_one':*'
	fi
	
	start_time=$new_start_time
	end_time=$new_end_time
	echo $new_start_time ' ' $new_end_time
}


increment_second(){
	#identify the digits which represent hour,minutes,seconds
	start_second=${start_time:6:2}
	end_second=${end_time:6:2}
	#add one hour,second,minute
	start_plus_one=$((10#$start_second + 1))
	end_plus_one=$((10#$end_second + 1))

	#if sum of above is just one digit, prepend a '0'
	if [ ${#start_plus_one} == 1 ]
	then
		new_start_time=$HOUR':'$MINUTE':0'$start_plus_one
	else
		new_start_time=$HOUR':'$MINUTE':'$start_plus_one
	fi
	
	if [ ${#end_plus_one} == 1 ]
	then
		new_end_time=$HOUR':'$MINUTE':0'$end_plus_one
	else
		new_end_time=$HOUR':'$MINUTE':'$end_plus_one
	fi
	
	start_time=$new_start_time
	end_time=$new_end_time
	echo $new_start_time ' ' $new_end_time
}

while [ $start_time != $HOUR':'$MINUTE':59' ]; do
	echo 'the start time is '$start_time >> $OUTPUT_FILE
	echo 'the end time is '$end_time >> $OUTPUT_FILE
	sed -n "/2017:$start_time/,/2017:$end_time/p" $LOG_FILE | wc -l >> $OUTPUT_FILE
	#increment_hour
	#increment_minute
	increment_second
done

#echo 'the start time is 23:1*:*'
#echo 'the end time is 23:59:*'
#grep '2017:23:0*:*' $LOG_FILE | wc -l >> counts.txt



getArray() {
    array=() # Create array
    while IFS= read -r line # Read a line
    do
        array+=("$line") # Append line to the array
    done < "$1"
}

getArray "/Users/esther/Desktop/bissell_logs/Core/request/queries/$OUTPUT_FILE"

for e in "${array[@]}"
do
    echo "$e"
done

#add up all lines
#for i in ${array[@]}; do
#  let tot+=$i
#done
#echo "Total: $tot" >> counts.txt

#mv counts.txt counts_$LOG.txtsub
