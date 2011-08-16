#!/bin/bash
set -e
clear
echo -e '\033[37;44m'"\033[1m *** Antorcha installatie script *** \033[0m"
echo
echo

echo -e "\033[1m Antorcha downloaden \033[0m"
echo
git clone git://github.com/thebeanmachine/antorcha.git antorcha
echo
echo -e "\033[1m Gereed! \033[0m"

echo
cd antorcha
mkdir db/shared
git checkout origin/maint -b maint
git pull
echo

echo
echo -e "\033[1m Initialisatie submodules \033[0m"
echo
git submodule init

echo
echo -e "\033[1m Gereed! \033[0m"
echo

echo
echo -e "\033[1m Bijwerken submodules \033[0m"
echo
git submodule update

echo
echo -e "\033[1m Gereed! \033[0m"
echo

echo
echo -e "\033[1m Noodzakelijke gems installeren \033[0m"
echo

gem install rails -v 2.3.12 --no-ri --no-rdoc 
gem install rspec --no-rdoc --no-ri   
RAILS_ENV=production rake gems:install

echo
echo -e "\033[1m Gereed! \033[0m"
echo

echo
echo -e "\033[1m Database configureren en installeren \033[0m"
echo

mkdir log
chmod 777 log -R
mkdir tmp
mkdir tmp/pids
chmod 777 tmp -R
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed

echo
echo -e "\033[1m Gereed! \033[0m"
echo

echo -e '\033[37;44m'"\033[1m *** Antorcha is geinstalleerd! *** \033[0m"
echo

echo 
echo -e '\033[37;44m'"\033[1m U dient nu uw webserver dusdanig te configureren. \033[0m"
echo