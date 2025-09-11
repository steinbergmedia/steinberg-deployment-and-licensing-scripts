#!/bin/zsh
#
# $Author:  $
# $Date:  $
# $Revision:  $

# Abort on any errors
set -e

# Change the working directory to the directory of this script
cd -- "$(dirname "$0")"

# Path to the license engine executable
LICENSE_ENGINE_EXECUTABLE="/Library/Application Support/Steinberg/Activation Manager/Steinberg License Engine.app/Contents/MacOS/Steinberg License Engine"

## ----------------------------------------------------------------------
function run_main() {
    local serial_number
    serial_number=$(get_computer_serial_number)
    local computer_name
    computer_name=$(get_computer_name)
    local license_request_filename="${PATH_TO_LICENSE_FILES}license-request-file-$serial_number.smtgreq"

    echo "Generating license request file for $computer_name with serial number $serial_number"

    if [ -f "$LICENSE_ENGINE_EXECUTABLE" ]; then
        echo "Using Steinberg License Engine to generate license request file"
        generate_license_request_file_with_steinberg_activation_manager "$computer_name" "$serial_number" "$license_request_filename"
    else
        echo "Using custom method to generate license request file"
        generate_license_request_file_without_steinberg_activation_manager "$computer_name" "$serial_number" "$license_request_filename"
    fi
}

## ----------------------------------------------------------------------
function get_computer_name() {
    local computer_name
    computer_name=$(scutil --get ComputerName)
    echo "$computer_name"
}

## ----------------------------------------------------------------------
function generate_license_request_file_with_steinberg_activation_manager() {
    local computer_name=$1
    local computer_serial=$2
    local license_request_filename=$3

    local license_engine_output
    license_engine_output=$("$LICENSE_ENGINE_EXECUTABLE" --generate-license-request "$license_request_filename")
}

## ----------------------------------------------------------------------
function generate_license_request_file_without_steinberg_activation_manager() {
    local computer_name=$1
    local computer_serial=$2
    local license_request_filename=$3

    local hardware_id
    hardware_id=$(echo -n "$computer_serial" | shasum -a 256 | head -c 64)

    cat << EOM > "$license_request_filename"
{
    "computerName": "${computer_name}",
    "computerNameOverridden": false,
    "hardwareID": "${hardware_id}",
    "offlineActivationRequestVersion": 2
}
EOM
}

## ----------------------------------------------------------------------
function get_computer_serial_number() { 
    local serial_number
    serial_number=$(ioreg -c IOPlatformExpertDevice -d 2 | grep IOPlatformSerialNumber | awk -F\" '{print $4}')
    echo "$serial_number"
}

## ----------------------------------------------------------------------
run_main
