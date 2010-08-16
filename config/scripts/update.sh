#!/bin/bash
clear
echo -e '\E[37;44m'"\033[1m *** Antorcha update script *** \033[0m"
echo
echo

echo -e "\033[1m Update Antorcha \033[0m"
echo
git pull origin maint
echo
echo -e "\033[1m Done! \033[0m"

echo
echo -e "\033[1m Update submodules \033[0m"
echo
git submodule update

echo
echo -e "\033[1m Done! \033[0m"
echo

echo
echo -e "\033[1m Setup Antorcha \033[0m"
echo
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake gems:install

echo
echo -e "\033[1m Done! \033[0m"
echo

echo -e '\E[37;44m'"\033[1m *** Antorcha succesfull updates *** \033[0m"
echo

echo 
echo -e '\E[37;44m'"\033[1m Please go to http://localhost:3000, when the server is ready.\033[0m"
echo

echo
echo -e '\E[37;44m'"\033[1m *** Run the server at port 3000 *** \033[0m"
echo

RAILS_ENV=production script/server



