@echo off
cls
echo *** Antorcha Engine starten ***
echo.
echo  De Antorcha engine wordt gestart in productie modus
echo.
set RAILS_ENV=production
ruby script/delayed_job run