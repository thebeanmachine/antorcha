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
echo   Belangrijk: Zorg er voor dat u tijdens de installatie 
echo   'Run Git from the Windows Command Prompt' aanvinkt.
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
echo  De voorbereiding is klaar. U dient nu uw computer eerst te herstarten.
echo.
echo.
pause 
