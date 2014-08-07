#!/bin/bash

#### bmp #######

# A directory memory utility. Keep track of several pesky
# directories that you are bouncing in and out of.

# Joel Bremson - August 5, 2014


export DIR_INDEX=0
export DIR_ARR=( ${HOME} )
#shortcut to bmp_grab
grab() { bmp_grab; }

#grab pushes the curdir onto the array $DIR_ARR

#NOTES for bmp_check - uses array_contains <new dir> ${DIR_ARR[@]}
# then check value of $?. If $? = 1 then it isn't in the array
# (I think). If $?=0 then it is. 
bmp_grab() { array_contains `pwd` "${DIR_ARR[@]}"
		if [ $? -eq 1 ]; then
		   DIR_ARR=( ${DIR_ARR[*]} `pwd` ); 
		   echo grabbed `pwd`;
		   bmp_inc;
		   bmp_persist;
		   export DIR_ARR; 
		else
		  echo "directory on stack already"
		fi }

##bmp cd's to the next dir in $DIR_ARR
bmp() { bmp_inc; 
	cd ${DIR_ARR[$DIR_INDEX]};
	echo in `pwd`; }

##cat the bmp list
bmp_cat() { cat ~/.bmp_persist; }

##edit the bmp list
bmp_edit() { vi ~/.bmp_persist; 
		bmp_load; }

##Reset the .bmp_persist file
bmp_reset() { echo ${HOME} > ~/.bmp_persist; bmp_load; }

##load the .bmp_persist file into DIR_ARR
##PRIVATE
bmp_load() { DIR_ARR=( );
	    while read line; do 
		DIR_ARR=( ${DIR_ARR[@]} $line );
	    done < ~/.bmp_persist; 
	    export DIR_ARR; }

## creates the persistence file
##PRIVATE
bmp_persist() { cat /dev/null > ~/.bmp_persist; 
		for dir in ${DIR_ARR[*]}; do
			echo $dir >> ~/.bmp_persist
		done }
		
## increment the index counter
#PRIVATE
bmp_inc() { let c=$(( ($DIR_INDEX + 1) % ${#DIR_ARR[@]} )); 
		export DIR_INDEX=$c; } 

## check if a dir is already in DIR_ARRAY helper
#PRIVATE
array_contains () {
    local seeking=$1; shift
    local in=1
    for element; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

# help doc
bmp_help() { echo "
bmp - a directory memory utility
---------------------------------------------------------------

bmp is a simple tool for keeping track of directories that you 
frequently jump between. It is written in bash and should run
on any modern bash (although it has not been tested). The bmp 
file is persistent, so it will work across sessions. 


Commands:
--------------------------------------------------------------
bmp_grab 	Remember the current directory in bmp.
grab		An alias to bmp_grab.
bmp     	Jump (i.e. cd)p to the next directory in bmp.
bmp_edit	Edit and reload the bmp file (with vi).
bmp_help	Print this help message. 
bmp_cat		Print the bmp directory list.		
bmp_reset	Reset the bmp directory list to the default.


Usage
--------------------------------------------------------------

When you are in a directory whose path you want to recall, use
the 'grab' command with no arguments. bmp will now remember 
that directory. 

To cycle through your directory list type 'bmp'. This will 
advance you through the bmp directory list one by one, cycling 
at the end of the list.

You can edit your bmp list with bmp_edit, which uses vi, or 
hand edit ~/.bmp_persist. To just look at your list type 
'bmp_cat'. 


Joel Bremson
August 6, 2014"; }

## get bmp setup on load.
bmp_load
