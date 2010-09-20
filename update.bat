@echo off
cls
echo *** Antorcha update script ***
echo.
echo  Antorcha bijwerken
echo.

call git checkout origin/maint -b maint
call git pull

echo.
echo    Gereed!
echo.

pause

echo.
echo  Submodules bijwerken
echo.

call git submodule init
call git submodule update

echo.
echo    Gereed!
echo.

pause

echo.
echo  Gems en database bijwerken
echo.

set RAILS_ENV=production 
call rake gems:install
call rake db:migrate

echo.
echo    Gereed!
echo.

echo
echo *** Antorcha is bijgewerkt! ***
echo