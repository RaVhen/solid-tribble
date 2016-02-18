#!/bin/bash

# Contains commonly used functions

. ./includes/variables.sh



timestamp() {
	date +"%Y-%m-%d_%H-%M-%S"
}

clean() {
	rm $FOUTPUT_NAME*
}

################################################################################
####                                                                        ####
####                         LOG FUNCTIONS                                  ####
####                                                                        ####
################################################################################

LOG=$PROJECT_PATH"/log/"$LOG_NAME"-"`timestamp`

debug() {
	if [ -z "$1" ]; then
		echo "No arguments passed to debug function"
	else
		echo "`date +"%Y-%m-%d_%H:%M:%S"`-DEBUG: $1" >> $LOG
	fi
}

error() {
	if [ -z "$1" ]; then
		echo "No arguments passed to error function"
	else
		echo "`date +"%Y-%m-%d_%H:%M:%S"`-ERROR: $1" >> $LOG
	fi
}

################################################################################
####                                                                        ####
####    Convert pathfile to absolute                                        ####
####                                                                        ####
################################################################################


abs_path() {
	if [ -z "$1" ]; then
		echo "No arguments passed to abs_path function"
	else
		if [ "$1" = "/" ]; then
			echo "/"
		else
			#echo "$(cd "$(dirname "$1")"/; pwd)/$(basename "$1")"
			echo "$(cd `dirname "$1"` && pwd)/`basename "$1"`"
		fi
	fi
}

