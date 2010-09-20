@echo off
cls
echo *** Antorcha update script ***
echo.
echo  Antorcha bijwerken
echo.

git checkout origin/maint -b maint
git pull

echo.
echo    Gereed!
echo.

pause

echo.
echo  Submodules bijwerken
echo.

git submodule init
git submodule update

echo.
echo    Gereed!
echo.

pause

echo.
echo  Gems en database bijwerken
echo.

RAILS_ENV=production rake gems:install
RAILS_ENV=production rake db:migrate

echo.
echo    Gereed!
echo.

echo
echo *** Antorcha is bijgewerkt! ***
echo