# $Author:  $
# $Date:  $
# $Revision:  $

# Set the working directory to the same directory as this script
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -Path $scriptPath

# Get the path to the Steinberg License Engine
$steinbergLicenseEnginePath = Resolve-Path -Path "$env:CommonProgramFiles\Steinberg\Activation Manager\SteinbergLicenseEngine.exe"
# Get the computer name
$computerName = $env:COMPUTERNAME
# Get the Steinberg Licensing hardware ID by invoking the license engine
$hardwareID = & $steinbergLicenseEnginePath --show-hardware-id

# Look for any filename that contains the computer name and ends with .smtglic



# Construct the path of the licence file to install based on the computer name and hardware ID
$licenseFileFilter = "*$($computerName)*.smtglic"

# Output the license file filter
Write-Output "Looking for license file with filter '$licenseFileFilter'"

# Does the license file exist?
if ((Test-Path $licenseFileFilter -PathType Leaf )) {
# If the license file does exist, install it for all users

    # Expand the wildcard to get the full path of the license file
    $licenseFileName = Get-Item $licenseFileFilter
    Write-Output "Installing license file '$($licenseFileName)'"

    & $steinbergLicenseEnginePath --install-licenses $licenseFileName --force --allusers
} else {
    # If the license file does not exist, display an error message
    Write-Error "License file not found for computer '$($computerName)' with hardware ID '$($hardwareID)'"
}

# Pause the script so that the user can read the output
Read-Host -Prompt "Press Enter to continue..."