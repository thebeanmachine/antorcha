@echo off
cls
echo *** Antorcha voorbereidingsscript ***
echo.
echo  Ruby installeren
echo   Het ruby installatie programma wordt gestart . . .
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
echo   Het Git installatie programma wordt gestart . . .
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
