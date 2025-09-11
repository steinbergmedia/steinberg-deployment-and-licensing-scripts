:: $Author:  $
:: $Date:  $
:: $Revision:  $

@echo off 
setlocal

set "LICENSE_ENGINE_PATH=%CommonProgramFiles%\Steinberg\Activation Manager\SteinbergLicenseEngine.exe"

:: Set this variable to "true" if you want the license to be install for any user who logs into the computer
set INSTALL_FOR_ALL_USERS=true

:: Install the license file
if %INSTALL_FOR_ALL_USERS%==true (
    "%LICENSE_ENGINE_PATH%" ^
         --install-licenses "steinberg-license-%COMPUTERNAME%.smtglic" --allusers
) else (
    "%LICENSE_ENGINE_PATH%" ^
         --install-licenses "steinberg-license-%COMPUTERNAME%.smtglic"
)

endlocal

:: Remove this pause if you are running this script in an automated way
pause