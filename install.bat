@echo off
cls
echo *** Antorcha installatie script ***
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