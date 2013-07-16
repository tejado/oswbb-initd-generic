#!/bin/bash
########################################################################
#
# Helper file for Oracle OSWatcher
#	by Tommy Reynolds <Tommy.Reynolds@MegaCoder.com>
#
#
# ported to Solaris from Oracle oswbb-service RPM
#	by Tjado Mäcke <tjado@maecke.de>
#
########################################################################

########################################################################
# Establish default values
########################################################################
# Set OSW_HOME to the directory where your OSWatcher tools are installed
OSW_HOME="/opt/oswbb"
# Set OSW_INTERVAL to the number of seconds between collections
OSW_INTERVAL="30"
# Set OSW_RETENTION to the number of hours logs are to be retained
OSW_RETENTION="48"
# Set OSW_USER to the owner of the OSW_HOME directory
OSW_USER="root"
# Set OSW_COMPRESSION to the desired compression scheme
OSW_COMPRESSION="gzip"
# Set OSW_ARCHIVE_BASE to path where "archive" will be created in
OSW_ARCHIVE_BASE="${OSW_HOME}"
########################################################################

########################################################################
# pull in configuration settings
########################################################################
[ -f //etc/oswbb.conf ] && . //etc/oswbb.conf
########################################################################

########################################################################
# Some internal settings
########################################################################

SU=/bin/su
RM=/bin/rm
TOUCH=/usr/bin/touch
ECHO=/usr/ucb/echo
ECHO_T=/usr/bin/echo
MKDIR=/usr/bin/mkdir
NOHUP=/usr/bin/nohup
SLEEP=/usr/bin/sleep


########################################################################
# start: push archive dir to timestamped backup, start new collection
########################################################################

start() {
	# exit on any error
	set -e 

	OSW_ARCHIVE_NAME=archive
	OSW_ARCHIVE_PATH=${OSW_ARCHIVE_BASE}/${OSW_ARCHIVE_NAME}
	OSW_ARCHIVE_SAVE=${OSW_ARCHIVE_NAME}-`/bin/date +'%Y-%m-%d-%H_%M_%S'`

	cd "${OSW_ARCHIVE_BASE}"

	# move current archive to save previous data 
	# e.g. after system crash for root-cause analysis
	if [ -d ${OSW_ARCHIVE_NAME} ]; then
		mv -f ${OSW_ARCHIVE_NAME} ${OSW_ARCHIVE_SAVE}
	fi;

	${MKDIR} -p ${OSW_ARCHIVE_NAME}

	cd "${OSW_HOME}"
	
	# start OSWatcher
	# for backwards compatibility, startOSW.sh will be checked
	for PROGRAM in ./startOSWbb.sh ./startOSW.sh; do
		if [ -x "${PROGRAM}" ]; then
			${NOHUP} "${PROGRAM}"				\
				"${OSW_INTERVAL}"				\
				"${OSW_RETENTION}"				\
				"${OSW_COMPRESSION}"			\
				"${OSW_ARCHIVE_PATH}"			\
				> ${OSW_ARCHIVE_PATH}/heartbeat 2>&1 &
			exit $?
		fi
	done
}


########################################################################
# stop: stop the service
########################################################################

stop() {
	# exit on any error
	set -e
	
	cd "${OSW_HOME}"
	
	# stop OSWatcher
	# for backwards compatibility, startOSW.sh will be checked
	for PROGRAM in ./stopOSWbb.sh ./stopOSW.sh; do
		if [ -x "${PROGRAM}" ]; then
			exec ${PROGRAM}
		fi
	done
}

########################################################################
# Decide what to do based on first comand line arg
########################################################################

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	*)
		${ECHO} "Usage: $0 {start|stop|}"
esac

exit 1
