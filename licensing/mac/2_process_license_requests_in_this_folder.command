#!/bin/zsh
#
# $Author:  $
# $Date:  $
# $Revision:  $

LICENSE_ENGINE_EXECUTABLE="/Library/Application Support/Steinberg/Activation Manager/Steinberg License Engine.app/Contents/MacOS/Steinberg License Engine"

# Customise this line to include the licenses you want to be on the target computer.  Separate multiple products with a semi-colon
LICENSES_TO_GENERATE="Dorico Pro 4"

# Abort on any errors
set -e

# Change the working directory to the directory of this script
cd -- "$(dirname "$0")"

function run_main() {

    # Iterate over all the license request files in the current directory
    for license_request_file in *.smtgreq; do
        if [ -f "$license_request_file" ]; then

            # Replace the smtgreq extension with smtglic to get the output filename
            local license_output_filename="${license_request_file%.*}.smtglic"
            # Remove the word "request" from the output filename
            license_output_filename="${license_output_filename/-request/}"
            

            echo "Processing license request file: $license_request_file"
            process_license_request_file "$license_request_file" "$LICENSES_TO_GENERATE" "$license_output_filename"
        fi
    done

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

run_main