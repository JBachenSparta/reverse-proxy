# Reverse Proxy

## Setup

Clone the package down to your local host. Cd into that folder directory and run :
```bash
vagrant up
```
Once this has finished, run:

```bash
vagrant ssh app
```

Finally run:

```bash
cd /vagrant/app
npm start
```

Terminal should say "Your app is ready and listening on port 3000
"

### Explanation


The purpose of a reverse proxy is two-fold:
- Simplification or the URL

Instead of needing to type in the port number, after the url (http://development.local:3000) using a reverse proxy redirects a user automatically to the correct port.  Now we can search (http://development.local/) and go directly to our destination page.  This looks much cleaner, and will make more sense to the uneducated user.

- Security

A reverse proxy forces a user to interact directly with proxy as opposed to connecting to the database itself. The proxy acts as an extra layer of padding between the user and the database, as the database is only accessible via the proxy, meaning a hacker or someone will ill intent must also first go through the proxy before being able to interact with the database itself.


## Automating the process

Within /environment/app/provision.sh there is the script that automates the process of setting up the reverse proxy.  It works as follows:

```bash
sudo apt-get update -y
```

Checks for any updates available to the current packages and repositories

```bash
sudo apt-get upgrade -y
```
Installs any updates found by the update command

```bash
sudo apt-get install nginx -y

```
Installs Nginx, which will act as out proxy

```bash
sudo unlink /etc/nginx/sites-enabled/default
```

Removes the symbolic link, between the default port used (80) and nginx.  IF you now search http://development.local/ it will not display the nginx page

```bash
cd /etc/nginx/sites-available

```

Terminal is changing directory to /sites-available, this is where we will add our new symbolic link to redirect our nginx to our database.   

```bash
sudo touch reverse-proxy.conf
```
Within our current directory creates a new file revers-proxy.conf

```bash
sudo chmod 666 reverse-proxy.conf
```
Changes permissions of the new file to 666, allowing owner, groups and all read and write privileges

```bash
sudo echo "
server {
  listen 80;
  location / {
    proxy_pass http://192.168.10.100:3000;
  }
}" >> reverse-proxy.conf
```
Echo's the string and redirects echo into the reverse-proxy.conf.  We would not have been able to do this without setting the permissions first.  

This string is what will redirect the user to our database. It is listening out for port 80, the default, but when the URL is searched instead it will display the proxy_pass URL, which is the url and port to our database.

```bash
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
```

Creates a symbolic link between the revers-proxy.conf file created and the sites enabled folder

```bash
sudo service nginx configtest
```
Super user commands a test to be run testing the configuration

```bash
sudo service nginx restart
```
Reconfigures the connection

```bash
sudo apt-get install git -y
```
Installs git
```bash
sudo apt-get install python-software-properties
```
Installs python
```bash
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
```
Installs node version 6
```bash
sudo apt-get install nodejs -y
```
Installs nodejs
```bash
cd /vagrant/app
```
changes directory back to /vagrant/app
```bash
npm install
```
Installs npm, which will allow us to run app.js in the current directory

```bash
sudo npm install pm2 -g
```
Installs PM2
