#!/bin/bash
set -e
clear
echo -e '\033[37;44m'"\033[1m *** Antorcha updatescript *** \033[0m"
echo
echo

echo -e "\033[1m Antorcha bijwerken \033[0m"
echo
git checkout maint
git pull origin maint
echo
echo
echo -e "\033[1m Antorcha is bijgewerkt! \033[0m"

echo
echo -e "\033[1m Submodules bijwerken \033[0m"
echo
git submodule init
git submodule update

echo
echo -e "\033[1m Submodules zijn bijgewerkt! \033[0m"
echo

echo
echo -e "\033[1m Databases en gem-bibliotheken bijwerken \033[0m"
echo
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake gems:install

echo
echo -e "\033[1m Databases en gem-bibliotheken zijn bijgewerkt! \033[0m"
echo

echo
echo -e "\033[1m Cache opschonen \033[0m"
echo
rm public/javascripts/all.js
rm public/javascripts/jquery.js
rm public/stylesheets/all.css

echo
echo -e "\033[1m Cache is opgeschoond! \033[0m"
echo


echo -e '\033[37;44m'"\033[1m *** Antorcha en haar componenten zijn bijgewerkt! *** \033[0m"
echo

echo
echo -e '\033[37;44m'"\033[1m *** Herstart Passenger *** \033[0m"
echo

# Onderstaande regel werkt enkel voor Passenger
touch tmp/restart.txt



