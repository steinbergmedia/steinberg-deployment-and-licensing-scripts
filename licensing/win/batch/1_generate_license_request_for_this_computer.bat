:: $Author:  $
:: $Date:  $
:: $Revision:  $

@echo off 
setlocal

set "LICENSE_ENGINE_PATH=%CommonProgramFiles%\Steinberg\Activation Manager\SteinbergLicenseEngine.exe"

:: Generate a request file  
"%LICENSE_ENGINE_PATH%" ^
     --generate-license-request "steinberg-license-request-%COMPUTERNAME%.smtgreq"

endlocal

:: Remove this pause if you are running this script in an automated way
pause