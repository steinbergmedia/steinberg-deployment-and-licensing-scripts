#!/bin/bash
#
# $Author: Ben Timms $
# $Date: Wed Apr 19 13:46:57 2023 +0100 $
# $Revision: 6621fe7 $

LICENSE_ENGINE_EXECUTABLE="/Library/Application Support/Steinberg/Activation Manager/Steinberg License Engine.app/Contents/MacOS/Steinberg License Engine"

# Customise this line to include the licenses you want to be on the target computer.  Separate multiple products with a semi-colon
LICENSES_TO_GENERATE="Dorico Pro 6 (Multi)"

## ----------------------------------------------------------------------
generate_license_request_file() { 
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
    # echo "Name: $computer_name"
    # echo "Serial: $computer_serial"
}
## ----------------------------------------------------------------------
process_license_request_file() {
    local license_request_filename="$1"
    local products_to_activate="$2"
    local output_license_filename="$3"


    COMMAND="\"$LICENSE_ENGINE_EXECUTABLE\" --process-license-request \"$license_request_filename\" --products \"$products_to_activate\" --output-license-file \"$output_license_filename\""
    echo "Invoking $COMMAND"
    eval "$COMMAND"
    retVal=$?
    if [ $retVal -ne 0 ]; then
         echo "Error processing license request"
         echo $retVal
         exit $retVal
    fi
}
## ----------------------------------------------------------------------
while read -r name_and_serial
do 
    read -r computer_name serial_number <<< "$name_and_serial"

    # Ensure that computer_name and serial_number are set
    if [ -z "$computer_name" ] || [ -z "$serial_number" ]; then
        echo "Skipping line: computer_name and serial_number must be set"
        # Skip to the next iteration of the loop
        continue
    fi

    license_request_filename="license-request-file-$serial_number.smtgreq"
    license_output_filename="license-file-$serial_number.smtglic"

    # Generate the request file
    generate_license_request_file "$computer_name" "$serial_number" "$license_request_filename"
    # Process the request file and generate a license file
    process_license_request_file "$license_request_filename" "$LICENSES_TO_GENERATE" "$license_output_filename"
    # Delete the request file
    rm "$license_request_filename"

    # EDIT THE LIST BELOW WITH A TAB SEPARATING THE COMPUTER NAME AND SERIAL NUMBER
done <<EOM
EXAMPLE_COMPUTER_NAME1	C02EXAMPLESERIAL1
EXAMPLE_COMPUTER_NAME2	C02EXAMPLESERIAL1
EXAMPLE_COMPUTER_NAME3	C02EXAMPLESERIAL2
EXAMPLE_COMPUTER_NAME4	C02EXAMPLESERIAL2
EOM