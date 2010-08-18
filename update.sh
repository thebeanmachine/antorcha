#!/bin/bash
clear
echo -e '\033[37;44m'"\033[1m *** Antorcha update script *** \033[0m"
echo
echo

echo -e "\033[1m Antorcha bijwerken \033[0m"
echo
ssh-add ./install_key
git pull origin maint
echo
echo -e "\033[1m Gereed! \033[0m"

echo
echo -e "\033[1m Submodules bijwerken \033[0m"
echo
git submodule init
git submodule update

echo
echo -e "\033[1m Gereed! \033[0m"
echo

echo
echo -e "\033[1m Databases en gem-bibliotheken bijwerken \033[0m"
echo
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake gems:install

echo
echo -e "\033[1m Gereed! \033[0m"
echo

echo -e '\033[37;44m'"\033[1m *** Antorcha is bijgewerkt! *** \033[0m"
echo

echo
echo -e '\033[37;44m'"\033[1m *** Herstart Passenger *** \033[0m"
echo

# Onderstaande regel werkt enkel voor Passenger
touch tmp/restart.txt



