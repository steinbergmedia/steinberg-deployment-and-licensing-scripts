#!/bin/bash

: <<'HEADER'

Script to install Dorico 6 and libraries
By Dan Gregory @ Jigsaw24
Updated Russ Collis @ Jigsaw24

Modified 20250729 by Mike Meyers
Updated 2025-08-05 by Ben Timms (Steinberg)

Apps 20250728

https://o.steinberg.net/en/support/downloads/dorico_6.html
Dorico Pro 6.0.22 Application · 595 MB
HALion Sonic 7.1 · VST Instrument · 923 MB

HEADER

set -x
exec 1>> /var/tmp/Dorico6Installer.log 2>&1

###########
# VARIABLES
###########

# Global
loggedInUser=$("/usr/bin/stat" -f%Su "/dev/console")
TmpPath="/private/tmp/Steinberg"
scriptLog="/var/tmp/steinberginstall.log"
PROGRESSFILE="$TmpPath/slm-progress.txt"
export SIA_EXECUTABLE="/Library/Application Support/Steinberg/Install Assistant/Steinberg Install Assistant.app/Contents/MacOS/Steinberg Install Assistant"
SLM_EXECUTABLE="/Applications/Steinberg Library Manager.app/Contents/MacOS/Steinberg Library Manager"

# Dependencies and Dorico Elements 6 installer
SAMURL="https://www.steinberg.net/sam-mac"
SLMURL="https://www.steinberg.net/slm-mac"
SMBURL="https://www.steinberg.net/smb-mac"
SIAURL="https://www.steinberg.net/sia-mac"
DESURL="https://download.steinberg.net/automated_updates/sda_downloads/8b36e0c8-85a8-43ed-811a-d2647770079c/Dorico_6.0.22_Installer_mac.dmg"


# HALion Sonic VST Instrument and Content
HALionSonicVSTInstrument="https://download.steinberg.net/automated_updates/sda_downloads/d088d1e6-5a2d-4a05-be91-e59860cf6f16/Halion_Sonic_7.1.40_Installer_mac.dmg" ##
HALionSonic7Content="https://download.steinberg.net/downloads_software/SDA/HALion_Sonic_Selection_Content.iso"

# Orchestral sound content libraries
HALionSymphonicOrchestraContent="https://download.steinberg.net/downloads_software/SDA/HALion_Symphonic_Orchestra_Content.iso"
IconicaSketch="https://download.steinberg.net/downloads_software/SDA/Iconica_Sketch.iso"

# Groove Agent SE 5 VST Instrument and content
GrooveAgentVSTInstrument="https://download.steinberg.net/automated_updates/sda_downloads/48bc9dfe-de7a-470a-826a-0b8ae79f85ea/GrooveAgent_SE_5.2.20_Installer_mac.dmg"
GrooveAgentSE5Content="https://download.steinberg.net/downloads_software/SDA/Groove_Agent_SE_5_Content.iso"

# Other content
OlympusChoirMicroContent="https://download.steinberg.net/automated_updates/sda_downloads/d4ce967a-45a0-451b-b163-3c44cd952ee8/Soundiron_Olympus_Micro.vstsound"
IndianDrumBasicsContent="https://download.steinberg.net/automated_updates/sda_downloads/f4ab5a63-24b5-49b0-ae6c-19cb4beb9cca/Indian_Drum_Basics.vstsound"

MarchingPercussionContent="https://download.steinberg.net/automated_updates/sda_downloads/a685e0ce-392f-45b8-8eb7-b3049262517f/SMT_011_Marching_Percussion_Basics.vstsound"
JazzEssentialsContent="https://download.steinberg.net/downloads_software/SDA/Jazz_Essentials.iso"


###########
# FUNCTIONS
###########

# Logging
function updateScriptLog() {
	echo -e "$( date +%Y-%m-%d\ %H:%M:%S ) - ${1}" | tee -a "${scriptLog}"
}


###################
# PRE-FLIGHT CHECKS
###################

# Folder check
if [[ -d "$TmpPath" ]]; then
	updateScriptLog "PRE-FLIGHT CHECK: $TmpPath exists... deleteing and recreating."
	/bin/rm -r $TmpPath
	/bin/mkdir $TmpPath
	/bin/mkdir $TmpPath/Libraries
else
	/bin/mkdir $TmpPath
	/bin/mkdir $TmpPath/Libraries
	updateScriptLog "PRE-FLIGHT CHECK: $TmpPath doesnt exist... created"
fi


# Download the installer dependencies
/usr/bin/curl --location --silent "$SAMURL" -o "$TmpPath/SteinbergActivationManager.dmg"
/usr/bin/curl --location --silent "$SLMURL" -o "$TmpPath/SteinbergLibraryManager.dmg"
/usr/bin/curl --location --silent "$SMBURL" -o "$TmpPath/SteinbergMediaBay.dmg"
/usr/bin/curl --location --silent "$SIAURL" -o "$TmpPath/SteinbergInstallAssistant.pkg"
/usr/bin/curl --location --silent "$DESURL" -o "$TmpPath/SteinbergDoricoPro6.dmg"
updateScriptLog "DOWNLOAD: Core applications downloaded."

# # Download Sound Libraries
/usr/bin/curl --location --silent "$HALionSonicVSTInstrument" -o "$TmpPath/Libraries/HALionSonicVSTInstrument.dmg"
/usr/bin/curl --location --silent "$HALionSonic7Content" -o "$TmpPath/Libraries/HALionSonic7Content.iso"
/usr/bin/curl --location --silent "$IconicaSketch" -o "$TmpPath/Libraries/IconicaSketch.iso"
/usr/bin/curl --location --silent "$HALionSymphonicOrchestraContent" -o "$TmpPath/Libraries/HALion_Symphonic_Orchestra_Content.iso"
/usr/bin/curl --location --silent "$GrooveAgentVSTInstrument" -o "$TmpPath/Libraries/GrooveAgentVSTInstrument.dmg"
/usr/bin/curl --location --silent "$GrooveAgentSE5Content" -o "$TmpPath/Libraries/GrooveAgentSE5Content.iso"
/usr/bin/curl --location --silent "$OlympusChoirMicroContent" -o "$TmpPath/Libraries/Soundiron_Olympus_Micro.vstsound"
/usr/bin/curl --location --silent "$IndianDrumBasicsContent" -o "$TmpPath/Libraries/IndianDrumBasics.vstsound"
/usr/bin/curl --location --silent "$MarchingPercussionContent" -o "$TmpPath/Libraries/SMT_011_Marching_Percussion_Basics.vstsound"
/usr/bin/curl --location --silent "$JazzEssentialsContent" -o "$TmpPath/Libraries/JazzEssentialsContent.iso"

updateScriptLog "DOWNLOAD: Sound libraries downloaded."

# Attach, extract pkg and install Steinberg Install Assistant
sudo installer -pkg $TmpPath/SteinbergInstallAssistant.pkg -target /
updateScriptLog "INSTALL: Installed Steinberg Install Assistant"

# Install Steinberg Activation Manager
"$SIA_EXECUTABLE" --install $TmpPath/SteinbergActivationManager.dmg --status-file /tmp/status.log --artifact-id sam
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Steinberg Activation Manager"

# Install Steinberg Library Manager
"$SIA_EXECUTABLE" --install $TmpPath/SteinbergLibraryManager.dmg --status-file /tmp/status.log --artifact-id slm
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Steinberg Library Manager"

# Install Steinberg Media Bay
"$SIA_EXECUTABLE" --install $TmpPath/SteinbergMediaBay.dmg --status-file /tmp/status.log --artifact-id smb
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Steinberg Media Bay"

# Install Steinberg Dorico Pro 6
"$SIA_EXECUTABLE" --install $TmpPath/SteinbergDoricoPro6.dmg --status-file /tmp/status.log --artifact-id dorico
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Steinberg Dorico Pro 6"


# Install the HALion Sonic VST Instrument
"$SIA_EXECUTABLE" --install $TmpPath/Libraries/HALionSonicVSTInstrument.dmg --status-file /tmp/status.log --artifact-id halionsonic
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed HALiaon Sonic VST Instrument"


# Install the Groove Agent VST Instrument
"$SIA_EXECUTABLE" --install $TmpPath/Libraries/GrooveAgentVSTInstrument.dmg --status-file /tmp/status.log --artifact-id grooveagent
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Groove Agent VST Instrument"

# Attach and Install HALion Sonic 7 Content
hdiutil attach -mountpoint /Volumes/HALionSonic7Content "$TmpPath/Libraries/HALionSonic7Content.iso"
"$SLM_EXECUTABLE" "/Volumes/HALionSonic7Content" -unattended -hide -copyto configured -progressFile $PROGRESSFILE
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
hdiutil detach "/Volumes/HALionSonic7Content" -force
# Dynamically find the mount point for HALion Sonic 7 Content and detach it
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed HALion Sonic 7 Content"

# Attach and Install HALion Symphonic Orchestra Content
hdiutil attach -mountpoint /Volumes/HALion_Symphonic "$TmpPath/Libraries/HALion_Symphonic_Orchestra_Content.iso"
"$SLM_EXECUTABLE" "/Volumes/HALion_Symphonic"  -unattended -hide -copyto configured -progressFile $PROGRESSFILE
sleep 5
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
hdiutil detach "/Volumes/HALion_Symphonic" -force
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed HALion Sonic 7 Content"

# Attach and Install Iconica Sketch
hdiutil attach -mountpoint /Volumes/IconicaSketch "$TmpPath/Libraries/IconicaSketch.iso"
"$SLM_EXECUTABLE" "/Volumes/IconicaSketch" -args -unattended -hide -copyto configured -progressFile "$PROGRESSFILE"
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
hdiutil detach "/Volumes/IconicaSketch" -force
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Iconica Sketch"

# IAttach and Install Groove Agent SE 5 Content
hdiutil attach -mountpoint /Volumes/GrooveAgentSE5Content "$TmpPath/Libraries/GrooveAgentSE5Content.iso"
"$SLM_EXECUTABLE" "/Volumes/GrooveAgentSE5Content" -args -unattended -hide -copyto configured -progressFile "$PROGRESSFILE"
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
hdiutil detach "/Volumes/GrooveAgentSE5Content" -force
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Groove Agent SE 5 Content"

# IAttach and Install Jazz Essentials Content
hdiutil attach -mountpoint /Volumes/JazzEssentialsContent "$TmpPath/Libraries/JazzEssentialsContent.iso"
"$SLM_EXECUTABLE" "/Volumes/JazzEssentialsContent" -args -unattended -hide -copyto configured -progressFile "$PROGRESSFILE"
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
hdiutil detach "/Volumes/JazzEssentialsContent" -force
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Jazz Essentials Content"

# Attach and Install Marching Percussion Content
"$SLM_EXECUTABLE" "$TmpPath/Libraries/SMT_011_Marching_Percussion_Basics.vstsound" -unattended -hide -copyto configured -progressFile "$PROGRESSFILE"
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Marching Percussion Content"

# Attach and Install Olympus Choir Micro
"$SLM_EXECUTABLE" "$TmpPath/Libraries/IndianDrumBasics.vstsound" -unattended -hide -copyto configured -progressFile "$PROGRESSFILE"
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Indian Drum Basics"

# Attach and Install Olympus Choir Micro
"$SLM_EXECUTABLE" "$TmpPath/Libraries/Soundiron_Olympus_Micro.vstsound" -unattended -hide -copyto configured -progressFile "$PROGRESSFILE"
while lsof "$PROGRESSFILE" &>/dev/null; do
	echo "Waiting for installation to complete..."
	sleep 1
done
echo "Installation is complete. Proceeding..."
updateScriptLog "INSTALL: Installed Olympus Agent SE 5 Content"
