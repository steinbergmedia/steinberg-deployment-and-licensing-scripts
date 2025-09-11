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

# Construct the path of the request file based on the computer name and hardware ID
$requestFilePath = "steinberg-license-request-$($computerName).smtgreq"

# Does the request file exist?
if (!(Test-Path $requestFilePath -PathType Leaf)) {
    # If it doesn't, generate the request file by invoking the license engine
    & $steinbergLicenseEnginePath --generate-license-request $requestFilePath
}
