#!/bin/bash
clear
echo -e '\E[37;44m'"\033[1m *** Antorcha installation script *** \033[0m"
echo
echo

echo -e "\033[1m Download Antorcha \033[0m"
echo
git clone git@github.com:thebeanmachine/antorcha.git antorcha
echo
echo -e "\033[1m Done! \033[0m"

echo
cd antorcha
mkdir db/shared
git checkout origin/maint -b maint
echo

echo
echo -e "\033[1m Download submodules \033[0m"
echo
git submodule init

echo
echo -e "\033[1m Done! \033[0m"
echo

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
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed
RAILS_ENV=production rake gems:install

echo
echo -e "\033[1m Done! \033[0m"
echo

echo -e '\E[37;44m'"\033[1m *** Antorcha succesfull installed *** \033[0m"
echo

echo 
echo -e '\E[37;44m'"\033[1m Please go to http://localhost:3000, when the server is ready.\033[0m"
echo

echo
echo -e '\E[37;44m'"\033[1m *** Run the server at port 3000 *** \033[0m"
echo

RAILS_ENV=production script/server



