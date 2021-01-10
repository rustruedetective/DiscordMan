@echo off


for /f "tokens=1,2 delims=#" %%a in (Profile.txt) do (
if %%a==Webhook set WEBHOOK_URL=%%b
if %%a==Username set USERNAME=%%b
if %%a==Email set email=%%b
if %%a==Password set password=%%b
if %%a==Channels set channels=%%b
)

set SCREENSHOTS=%CD%
FOR %%a in ("%SCREENSHOTS%") do set "SCREENSHOTS=%%~dpa"
FOR %%a in ("%SCREENSHOTS:~0,-1%") do set "SCREENSHOTS=%%~dpa"
SET SCREENSHOTS="%SCREENSHOTS%Pictures\Screenshots"
set WATCH=1
SET SourceFile2="Profile.txt"
SET OutputFile1="bin\temp15.ini"
FindStr ../Downloads %SourceFile2%>%OutputFile1%

cd bin

call:myDosFunc "config.ini" "temp.ini" "email" %email% "="
call:myDosFunc "config.ini" "temp.ini" "password" %password% "="
SET SourceFile2="config.ini"
SET OutputFile1="temp15.ini"
SET OutputFile2="temp2.ini"
FindStr /V ../Downloads %SourceFile2%>%OutputFile2%
DEL %SourceFile2%
MOVE %OutputFile2% %SourceFile2%
type %SourceFile2% %OutputFile1% > %OutputFile2%
DEL %SourceFile2%
DEL %OutputFile1%
MOVE %OutputFile2% %SourceFile2%


start dau.exe --webhook %WEBHOOK_URL% --directory %SCREENSHOTS% --username %USERNAME% --watch %WATCH% --no-watermark=
start discord-image-downloader-go-windows-amd64.exe


timeout 20
call:myDosFunc "config.ini" "temp.ini" "email" "" "="
call:myDosFunc "config.ini" "temp.ini" "password" "" "="
FindStr /V ../Downloads %SourceFile2%>%OutputFile2%
DEL %SourceFile2%
MOVE %OutputFile2% %SourceFile2%


echo.&goto:eof
::--------------------------------------------------------
::-- Function section starts below here
::--------------------------------------------------------
:myDosFunc
SETLOCAL EnableExtensions
SET SourceFile=%~1
SET OutputFile=%~2
SET "FindKey=%~3"
SET NewValue=%~4
REM Basic parse for INI file format.
(FOR /F "usebackq eol= tokens=1,* delims=%~5" %%A IN (`TYPE %SourceFile%`) DO (
    REM If the key value matches, build the line with the new value.
    REM Otherwise write out the existing value.
    IF /I "%%A"=="%FindKey%" (
        ECHO %%A=%NewValue%
    ) ELSE (
        ECHO %%A=%%B
    )
)) > %OutputFile%
REM Replace old with new.
DEL %SourceFile%
MOVE %OutputFile% %SourceFile%
ENDLOCAL
goto:eof