@echo off
cls
echo *** Antorcha installatie script ***
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
echo   ‘Run Git from the Windows Command Prompt’ aanvinkt.
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
echo  Antorcha downloaden
echo.
git clone git://github.com/thebeanmachine/antorcha.git antorcha
cd antorcha
mkdir db
mkdir db\shared
git checkout origin/maint -b maint
git pull

echo.
echo    Gereed!
echo.

pause

echo.
echo  Initialisatie submodules
echo.

git submodule init
git submodule update

echo.
echo    Gereed!
echo.

pause


echo.
echo  Noodzakelijke gems installeren
echo.

gem install rails -v 2.3.8
gem install rspec 
RAILS_ENV=production rake gems:install

echo.
echo    Gereed!
echo.

pause

echo.
echo  Database configureren en installeren
echo.

RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed

echo.
echo    Gereed!
echo.

echo.
echo *** Antorcha is geinstalleerd! ***
echo.
