@echo off
cls
echo *** Antorcha installatie script ***
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

set RAILS_ENV=production

gem install rails -v 2.3.8
gem install rspec 
rake gems:install

echo.
echo    Gereed!
echo.

pause

echo.
echo  Database configureren en installeren
echo.

set RAILS_ENV=production

rake db:create
rake db:migrate
rake db:seed

echo.
echo    Gereed!
echo.

echo.
echo *** Antorcha is geinstalleerd! ***
echo.
echo.
pause
