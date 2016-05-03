#!/bin/bash
#   This program accepts a path to a DIRECTORY as its first
#   command line argument, followed by one or more string PATTERNs
#   as the remaining command line arguments.
#
#   It must verify that it has at least 2 initial command line arguments
#   (the DIRECTORY and at least one PATTERN), and that the DIRECTORY is
#   in fact a directory. If any of these conditions fails, report an error
#   TO STANDARD ERROR and exits the script with an exit status of 1.
#   Otherwise proceed:
#
#   For each string pattern, it calls a shell function search()

#   search() accepts the DIRECTORY and current PATTERN as function arguments.
#       Find all of the *regular files* within and below the DIRECTORY
#       For each of those regular files
#           Run the file command and egrep for the pattern.
#           If the output from the file command satisfies the
#           egrep pattern, then:
#               Add 1 to a counter for the number of file types matching PATTERN.
#               Accumulate the number of lines in the file itself
#                   in a variable. 
#                   Accumulate the number of lines in the file.
#               Accumulate the number of words in the file itself in a
#                   different variable.
#               Accumulate the number of characters in the file itself in a
#                   third variable.
#       The search() function returns these four counters to the main
#           shell code that calls the function.


function search()
{
    fresult=`find $dirarg`
    countF=`file $fresult| egrep $2 | wc -l` #should loop through each result instead
                                             #string can be too large if there are a lot of files
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
