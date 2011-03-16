@echo off
cls
echo *** Antorcha herinitialisatie script ***
echo.
echo.
echo  Antorcha downloaden
echo.
echo.
echo  Database configureren en gebruiker toevoegen
echo.

set RAILS_ENV=production

call rake db:migrate
call rake db:seed