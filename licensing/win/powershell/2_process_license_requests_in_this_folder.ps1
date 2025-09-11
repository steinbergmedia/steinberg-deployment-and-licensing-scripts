# $Author:  $
# $Date:  $
# $Revision:  $

# Set the working directory to the same directory as this script
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location -Path $scriptPath

# Set the list of products you wish to activate here
$productsToActivate = "Dorico Pro 4"
$specificGrantsToActivate = ""

# Get the path to the Steinberg License Engine
$steinbergLicenseEnginePath = Resolve-Path -Path "$env:CommonProgramFiles\Steinberg\Activation Manager\SteinbergLicenseEngine.exe"

Get-ChildItem . -Filter *.smtgreq | 
Foreach-Object {

    $requestFilePath = $_.FullName
    $generatedLicenseFilePath = $requestFilePath -replace ".smtgreq", ".smtglic"

    Write-Output "Processing license request file '$($requestFilePath)'"

    if ($specificGrantsToActivate) {
        & $steinbergLicenseEnginePath --process-license-request $requestFilePath --grants "$($specificGrantsToActivate)" --output-license-file $generatedLicenseFilePath
    } elseif ($productsToActivate) {
        & $steinbergLicenseEnginePath --process-license-request $requestFilePath --products "$($productsToActivate)" --output-license-file  $generatedLicenseFilePath
    }
}

Pop-Location

# Pause the script so that the user can read the output
Read-Host -Prompt "Press Enter to continue..."