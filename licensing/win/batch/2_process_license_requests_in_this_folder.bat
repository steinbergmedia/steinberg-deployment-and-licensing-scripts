:: $Author:  $
:: $Date:  $
:: $Revision:  $

@echo off 
setlocal EnableDelayedExpansion

SET PATH_TO_THIS_SCRIPT=%~dp0
set "LICENSE_ENGINE_PATH=%CommonProgramFiles%\Steinberg\Activation Manager\SteinbergLicenseEngine.exe"

:: ------------------------------------------------------------------------
:: Customise this line to include the licenses you want to be on the target
:: computer.  Separate multiple products with a semi-colon.
::
:: For example: set PRODUCTS_TO_ACTIVATE="Dorico Pro 4;Cubase Pro 12"
:: 
set "PRODUCTS_TO_ACTIVATE=Cubase Pro 12"
set "GRANTS_TO_ACTIVATE="
:: By default, look in the same folder where this script is located.
:: Make sure it ends with a backslash.
SET PATH_TO_FOLDER_OF_REQUEST_FILES=%PATH_TO_THIS_SCRIPT%
:: ------------------------------------------------------------------------

:: Loop over the request files
for %%G in ("%PATH_TO_FOLDER_OF_REQUEST_FILES%*.smtgreq") do (
     SET "REQUEST_FILENAME=%%~G"
     SET "OUTPUT_LICENSE_FILENAME=!REQUEST_FILENAME:smtgreq=smtglic!"
     SET "OUTPUT_LICENSE_FILENAME=!OUTPUT_LICENSE_FILENAME:-request=!"
     @REM echo "Request filename !REQUEST_FILENAME!"
     @REM echo "output filename: !OUTPUT_LICENSE_FILENAME!"

     if exist "!OUTPUT_LICENSE_FILENAME!" (
          echo "License file !OUTPUT_LICENSE_FILENAME! already exists, please delete the file if you would like to regenerate it."
     ) else (
          :: If a product is specified
          if "%PRODUCTS_TO_ACTIVATE%" NEQ "" "%LICENSE_ENGINE_PATH%" ^
               --process-license-request "!REQUEST_FILENAME!" ^
               --products "%PRODUCTS_TO_ACTIVATE%" ^
               --output-license-file "!OUTPUT_LICENSE_FILENAME!"

          :: If a grant is specified
          if "%GRANTS_TO_ACTIVATE%" NEQ "" "%LICENSE_ENGINE_PATH%" ^
               --process-license-request "!REQUEST_FILENAME!" ^
               --grants "%GRANTS_TO_ACTIVATE%" ^
               --output-license-file "!OUTPUT_LICENSE_FILENAME!"
     )
)
endlocal
:: Remove this pause if you are running this script in an automated way
pause