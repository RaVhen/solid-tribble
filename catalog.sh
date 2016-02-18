#!/bin/bash

. ./includes/utils.sh


FOUTPUT=$PROJECT_PATH"/"$FOUTPUT_NAME"-"`timestamp`

path_starts_with_another_path() {
    path1="$1"
    path2="$2"
    if [[ $path1 == "$path2"* ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

read_file() {
	if [ -z "$1" ]; then
		error "ERROR: No arguments passed to contains function"
	elif [ ! -s "$1" ]; then
		error "ERROR: $1 is an empty file !"
	else
		retval="no"
		while read line; do
			if [[ ! $line == "#"* ]]; then
				# If $2 is subpath from $line
				retval=`path_starts_with_another_path "$2" "$line"`
				#echo $retval $line $2
				if [ "$retval" =  "yes" ]; then
					echo "IsSub"
					return 
				fi
				retval=`path_starts_with_another_path "$line" "$2"`
				#echo $retval $line $2
				if [ "$retval" =  "yes" ]; then
					echo "SubOf"
					return
				fi
			fi
		done < "$1"
	    echo "IsNothing"
	fi
		
}

# Recursively search for files in dir and subdir
recurse() {
	dir_end=""
	if [ "$1" = "/" ]; then
	   dir_end="*"
	else
		dir_end="/*"
	fi

	for element in "$1"$dir_end; do
		path_element=""
		if [ "$1" = "/" ]; then
			path_element="$element"
		else
			path_element=`abs_path "$element"`
		fi
		retval=`read_file "$USEFULL" "$path_element"`
		# If current path is subpath of a path in conf
		# fe: /etc/ssh is subpath of /etc
		
		if [ "$retval" = "IsSub" ]; then
			if [ -d "$element" ]; then
				debug "Going through $path_element"
				recurse "$element"
			else [ -f "$element" ]
				 abs_path "$element" >> $FOUTPUT
			fi
			# If path in conf is subpath of current path
			# fe : /etc/ssh has subpath /etc
			# Must continue to dig into dir but do no process
			# ant files
		elif [ "$retval" = "SubOf" ]; then
			if [ -d "$element" ]; then
				debug "Going through $path_element"
				recurse "$element"
			fi
			# If current path is totaly different from path in conf
			# Do nothing, just log
		else
			debug "Skipping $path_element"
		fi
	done
}


# Main
if [ -z "$1" ]; then
	echo "ERROR: No arguments found !"
	echo "Usage: ./catalog.sh <path_to_be_analyzed>\n"
	exit 1
else
	recurse "$1"
	echo "Done ! Files list saved in $FOUTPUT"
fi


