#!/usr/bin/env zsh
#
# $Author: Ben Timms $
# $Date: Wed Apr 19 13:46:57 2023 +0100 $
# $Revision: bd4bb81 $

USER_LICENSING_DATA_FOLDER="$HOME/Library/Application Support/Steinberg/Activation Manager/Data"
SHARED_LICENSING_DATA_FOLDER="/Library/Application Support/Steinberg/Activation Manager/Data"

# Default to not using sudo
SUDO=""

# Exit if any of the commands fail
set -e

# Exit if the user licensing data folder does not exist
if [[ ! -d "$USER_LICENSING_DATA_FOLDER" ]]; then
    echo "The folder $USER_LICENSING_DATA_FOLDER does not exist."
    exit 1
fi

# If the shared licensing data folder exists, ask the user whether we should continue
if [[ -d "$SHARED_LICENSING_DATA_FOLDER" ]]; then
    echo "The folder $SHARED_LICENSING_DATA_FOLDER already exists, any existing licenses will be replace.  Continue? (y/n) "
    read -k 1 answer
    echo ""

    if [[ ! $answer =~ [yY] ]]; then
        echo "Exiting."
        exit 1
    fi
fi

# Check whether we can write to /Library/Application Support/Steinberg/Activation Manager/Data
if [[ ! -w "$(dirname $SHARED_LICENSING_DATA_FOLDER)" ]]; then
    echo "You do not have write permissions to $SHARED_LICENSING_DATA_FOLDER."

    # Ask the user whether we should run this script with sudo
    echo -n "Do you want to try running the rest of this script with sudo? (y/n) "
    read -k 1 answer
    echo ""

    # Exit if the user does not want to run this script with sudo, otherwise set a variable for sudo
    if [[ $answer =~ [yY] ]]; then
        SUDO="sudo"
    else
        echo "Exiting."
        exit 1
    fi
fi

# Check to ensure that the access.txt or the offline.json file exists
if [[ ! -f "$USER_LICENSING_DATA_FOLDER/access.txt" && ! -f "$USER_LICENSING_DATA_FOLDER/offline.json" ]]; then
    echo "The file $USER_LICENSING_DATA_FOLDER/access.txt or $USER_LICENSING_DATA_FOLDER/offline.json does not exist."
    exit 1
fi

$SUDO rm -rf "$SHARED_LICENSING_DATA_FOLDER"
$SUDO cp -aR "$USER_LICENSING_DATA_FOLDER" "$SHARED_LICENSING_DATA_FOLDER"
echo "Copied license data from $USER_LICENSING_DATA_FOLDER to $SHARED_LICENSING_DATA_FOLDER"

# If the file access.txt exists, extract the value of the property licenseeMail and write it to a file called offline.json
if [[ -f "$USER_LICENSING_DATA_FOLDER/access.txt" ]]; then
    # Parse the JSON file access.txt and extract the value of the property licenseeMail
    licenseeMail=$(cat "$USER_LICENSING_DATA_FOLDER/access.txt" | sed -n 's/.*"userEmail":"\([^"]*\)".*/\1/p')

    # Write the JSON propert licenseeMail with the value $licenseeMail to a file called offline.json
    $SUDO echo "{\"licenseeMail\":\"$licenseeMail\"}" > "$SHARED_LICENSING_DATA_FOLDER/offline.json"

    # Remove the file access.txt from the shared licensing data folder
    $SUDO rm "$SHARED_LICENSING_DATA_FOLDER/access.txt"
fi

# If the file offline.json exists, copy it to the shared licensing data folder
if [[ -f "$USER_LICENSING_DATA_FOLDER/offline.json" ]]; then
    $SUDO cp "$USER_LICENSING_DATA_FOLDER/offline.json" "$SHARED_LICENSING_DATA_FOLDER/offline.json"
fi

echo "The currently activated licenses for this user account are now enabled for all users."
