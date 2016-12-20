@ECHO OFF
setlocal EnableExtensions EnableDelayedExpansion

rem: Author is Daniel Lee, 2016. Tested on Windows 8.1
rem Remember to run this batch script as an administrator
rem Remember to save a backup of your user env variables because it could be run into the truncated to 1024 char error
rem This is only for adding User path variables, due to the character limit of the system wide path env var

rem Start infinite loop
:loop
echo %PATH:;=&echo.%
echo Enter 1 to create a base user path
echo.Enter 2 to add a path
echo.Enter 3 to delete a path
echo.Enter 4 to exit the program

set /p INPUT=
IF /I "%INPUT%" == "1" (
   set /p ADDPATH=Enter a base user path:
   setx PATH "!ADDPATH!"
)

IF /I "%INPUT%" == "2" (
   set /p ADDPATH=Enter the path:
   
   for /f "skip=2 tokens=3*" %%a in ('reg query HKCU\Environment /v PATH') do (
   	if [%%b]==[] (
		setx PATH "%%~a;!ADDPATH!"
	) else ( 
		setx PATH "%%~a %%~b;!ADDPATH!" 
  	)
   )
)

IF /I "%INPUT%" == "3" (
   rem Warning! This deletes the whole registry key, not just the value data.
   rem Also remember to reboot your PC to confirm the changes
   echo Enter 1 to delete user path
   echo.Enter 2 to delete system path
   set /p CHOICE=
   IF /I "!CHOICE!" == "1" (
       set /p DELPATH=Enter the user path:
       reg delete HKCU\Environment /v !DELPATH!
   )
   IF /I "!CHOICE!" == "2" (
       rem This requires admin privileges
       rem Make sure to backup your system variables
       set /p DELPATH=Enter the system path:
       reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v !DELPATH!
   ) 

)

IF /I "%INPUT%" == "4" (
   echo Good Bye
   PAUSE
   EXIT /B 
)

goto loop

