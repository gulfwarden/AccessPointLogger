#!/bin/bash

### Variables ###
AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
TXRATE=0

### Functions ###

# Function for logging
function logger {
    echo $(date +"%Y-%m-%d %H:%M:%S") "$1"
    echo $(date +"%Y-%m-%d %H:%M:%S") "$1" >> "${LOGFILE}"
}

# Function for AirportUtilty
function getCurrentInformation {
	# get information from utilty
	lastTxRate=$("$AIRPORT" -I | grep lastTxRate | cut -d":" -f2 | tr -d [:blank:])
	maxRate=$("$AIRPORT" -I | grep maxRate | cut -d":" -f2 | tr -d [:blank:])
	BSSID=$("$AIRPORT" -I | grep BSSID | cut -d":" -f2- | tr -d [:blank:])
	SSID=$("$AIRPORT" -I | grep "\bSSID\b" | cut -d":" -f2- | tr -d [:blank:])
	channel=$("$AIRPORT" -I | grep channel | cut -d":" -f2 | tr -d [:blank:])

	# set channel to 2.4 or 5GHz

	if [ $channel -gt 15 ];
	then 
    	channelhertz=5
	else
    	channelhertz=2.4
	fi;
}

function getCurrentBSS {
	BSS=$(cat $CONFIG | grep "$SSID;$channelhertz;$1;" | cut -d";" -f4)

	if [ "$UPDATE" = "yes" ]; then
 		if [ -z "${BSS}" ]; then 
    		echo "$SSID;$channelhertz;$1;TBD" >> $CONFIG
		fi
	fi
}		

### Options ###

# Set variables from parameters
while getopts c:l:n: option
	do
		case "${option}" in
			c) CONFIG=${OPTARG};;
			l) LOGFILE=${OPTARG};;
			n) UPDATE=${OPTARG};;
			t) TIME=${OPTARG};;
		esac
done

# if no parameters are set, set defaults
if [ -z "${CONFIG}" ]; then 
    CONFIG=".config"
fi

if [ -z "${LOGFILE}" ]; then 
    LOGFILE="apl.log"
fi

if [ -z "${UPDATE}" ]; then 
    UPDATE="yes"
fi

if [ -z "${TIME}" ]; then 
    TIME="1"
fi

### Checks ###

# Check if needed executabels are present  
if [ -f $AIRPORT ]; then
   logger "Airport utilty found"
else
   logger "Airport utility not found, programm will terminate"
   exit 1
fi

### Main ### 

# Start the programm until CTRL-C is pressed
while [ 1 ]
do
	# Fill all variables
	getCurrentInformation

	# Get Name of Access Point from BSSID
	getCurrentBSS $BSSID

	if (( $lastTxRate > $TXRATE ));
	then 
		echo -e "\a"
    	logger "SSID: $SSID BSSID: $BSS ($BSSID) channel: $channelhertz GHz lastTxRate: $lastTxRate maxRate: $maxRate (New maximum TX rate)"
    	TXRATE=$lastTxRate
    else 
    	logger "SSID: $SSID BSSID: $BSS ($BSSID) channel: $channelhertz GHz lastTxRate: $lastTxRate maxRate: $maxRate (current Maximum: $TXRATE)"
	fi

	# Sleep and wait
    sleep $TIME
done

exit 0