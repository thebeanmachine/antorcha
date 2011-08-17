@echo off
cls
echo *** Antorcha voorbereidingsscript ***
echo.
echo 	Wij gaan er vanuit dat MySQL is geinstalleerd op de standaardpoort!
echo.
echo  Ruby installeren
echo   Het Ruby installatieprogramma wordt gestart . . .
echo.
echo   Belangrijk: Vergeet niet 'Add executables to path' aan te vinken
echo.
echo.
call bin\rubyinstaller.exe
echo.
echo    Gereed!
echo.
echo.
echo  Git installeren
echo.
echo   Belangrijk: U moet tijdens de installatie het volgende aanvinken: 
echo   'Run Git from the Windows Command Prompt'.
echo   'Add Git executables to your PATH'.
echo.

pause

echo.
echo   Het Git installatieprogramma wordt gestart . . .
echo.

call bin\gitinstaller.exe

echo.
echo    Gereed!
echo.
echo.
echo    Herstart de computer en voer daarna het bestand 'install.bat' uit.
echo.
echo.
pause 
