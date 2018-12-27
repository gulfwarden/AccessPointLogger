# AccessPointLogger
This tool can be used, to log and name all seen access points in a WIFI session. It´s useful, if you want to see, to which access points you are connected and which TX rate you can get.

The tool can be used on a Apple Mac but is BASH based.


# Usage
1. Get a copy of the source code
1. Make the bash-Script executable, if not already the case
    1. chmod +x apl.sh
1. run it
    1. ./apl.sh
    
# Files
* apl.sh -> the bash script to run everything
* apl.log -> the log file, where you see the history
* .config -> the config file, where you can add names for the different BSSIDs 

# Parameters:
-c CONFIG file, defaults to .config  
-l LOGFILE, defaults to apl.log  
-n UPDATE, defaults to yes (so the config file gets added new AP BSSIDs) 
-t TIME, defaults to 1 and sets the refresh/logging interval  
