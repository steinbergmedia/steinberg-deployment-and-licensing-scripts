#!/bin/zsh
#
# $Author:  $
# $Date:  $
# $Revision:  $
#
# Description:
#   This script will look for a license file matching the serial number of
#   the computer it is running on in the working directory.  If it finds
#   a readable license file, it will install it.

LICENSE_ENGINE_EXECUTABLE="/Library/Application Support/Steinberg/Activation Manager/Steinberg License Engine.app/Contents/MacOS/Steinberg License Engine"

# Change this parameter if you want to install the license for all users or not
INSTALL_LICENSE_FOR_ALL_USERS=true
PATH_TO_LICENSE_FILES="" # If this value is set to a folder, make sure it ends with a slash

# Abort on any errors
set -e

# Change the working directory to the directory of this script
cd -- "$(dirname "$0")"


## ----------------------------------------------------------------------
function run_main()
{
    local serial_number
    serial_number=$(get_computer_serial_number)
    local license_filename
    license_filename="${PATH_TO_LICENSE_FILES}license-file-$serial_number.smtglic"
    echo "Looking for $license_filename"
    if [[ -r $license_filename ]]; then
        install_license_request_file "$license_filename"
    else
        echo "Unable to read license file, does it exist?"
    fi
}

## ----------------------------------------------------------------------
function get_computer_serial_number() { 
    local serial_number
    serial_number=$(ioreg -c IOPlatformExpertDevice -d 2 | grep IOPlatformSerialNumber | awk -F\" '{print $4}')
    echo "$serial_number"
}

## ----------------------------------------------------------------------
function install_license_request_file() {
    local license_filename="$1"

    if [ "$INSTALL_LICENSE_FOR_ALL_USERS" = true ] ; then
        COMMAND="sudo \"$LICENSE_ENGINE_EXECUTABLE\" --install-licenses \"$license_filename\" --force --allusers"
    else
        COMMAND="\"$LICENSE_ENGINE_EXECUTABLE\" --install-licenses \"$license_filename\""
    fi
    echo "Invoking $COMMAND"
    eval "$COMMAND"
    retVal=$?
    if [ $retVal -ne 0 ]; then
         echo "Error processing license file"
         echo $retVal
         exit $retVal
    fi
}

run_main