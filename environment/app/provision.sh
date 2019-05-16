#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install nginx
sudo apt-get install nginx -y

sudo unlink /etc/nginx/sites-enabled/default

cd /etc/nginx/sites-available

sudo touch reverse-proxy.conf

sudo chmod 666 reverse-proxy.conf

sudo echo "
server {
  listen 80;
  location / {
    proxy_pass http://192.168.10.100:3000;
  }
}" >> reverse-proxy.conf

sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

sudo service nginx configtest

sudo service nginx restart

# install git
sudo apt-get install git -y

# install nodejs
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y

cd /vagrant/app

npm install
# install pm2
sudo npm install pm2 -g
