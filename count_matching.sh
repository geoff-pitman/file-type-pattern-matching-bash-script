#!/bin/bash
# Geoffrey Pitman
# shell3_2016.sh -- D. Parson solution to assignment 3, CSC 352 Unix
#   Spring 2016. This program accepts a path to a DIRECTORY as its first
#   command line argument, followed by one or more string PATTERNs
#   as the remaining command line arguments.

function search()
{
    fresult=`find $dirarg`
	countF=`file $fresult| egrep $2 | wc -l`
    countL=0
    countW=0
    countC=0
    
    if (( countF > 0 ))
    then
        for f in `file $fresult | egrep $2 | cut -d':' -f1`
		do
			tempL=`cat $f | wc -l`
			(( countL += tempL )) 
			tempW=`cat $f | wc -w`
			(( countW += tempW ))
			tempC=`cat $f | wc -c`
			(( countC += tempC ))
		done
    fi
	
	# (( $3=$4 )) is legal
	(( $3 = countF ))
	(( $4 = countL ))
	(( $5 = countW ))
	(( $6 = countC ))
}

if (( $# < 2 )) || [ ! -d $1 ]
then
	echo "ERROR">&2
	exit 1
else
	dirarg=$1	
	while (( $# > 1 ))
	do
		tempF=0
		tempL=0
		tempW=0
		tempC=0
		search $1 $2 tempF tempL tempW tempC
		if (( tempF >= 0 ))
		then
			echo "$2 $tempF files, $tempL lines, $tempW words, $tempC chars"
		fi
		shift
	done
fi
exit 0
