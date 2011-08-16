@echo off
cls
echo *** Antorcha installatiescript ***
echo.
echo.
echo  Antorcha downloaden
echo.
call git clone git://github.com/thebeanmachine/antorcha.git antorcha
cd antorcha
mkdir db
mkdir db\shared
call git checkout origin/maint -b maint
call git pull

echo.
echo    Gereed!
echo.

pause

echo.
echo  Initialisatie submodules
echo.

call git submodule init
call git submodule update

echo.
echo    Gereed!
echo.

pause


echo.
echo  Noodzakelijke gems installeren
echo.

set RAILS_ENV=production

call gem install rails -v 2.3.10 --no-rdoc --no-ri 
call gem install rspec --no-rdoc --no-ri  
call gem install rdoc
gem install rdoc-data
call rake gems:install

echo.
echo    Gereed!
echo.

pause

echo.
echo  Database configureren en installeren
echo.

set RAILS_ENV=production

call rake db:create
call rake db:migrate
call rake db:seed

echo.
echo    Gereed!
echo.

echo.
echo *** Antorcha is geinstalleerd! ***
echo Kopieer het bestand lib/mysql/libmySQL.dll in de 'bin' map van Ruby!
echo.
echo.
pause
