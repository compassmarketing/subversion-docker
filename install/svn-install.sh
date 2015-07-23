#! /bin/bash

MSG() {
        echo "=== $1"
}

ERROR() {
        echo "--- $1"
        exit 1
}

MSG 'Install Subversion'
DEBIAN_FRONTEND=noninteractive apt-get install -y subversion

MSG 'Adding Subversion server user and group'
adduser --system --shell /usr/sbin/nologin --no-create-home --disabled-login svnsrv
addgroup --system svnsrv
adduser svnsrv svnsrv

MSG 'Creating Subversion repo'
mkdir -p /srv/svn
chown svnsrv:svnsrv /srv/svn
sudo -u svnsrv -g svnsrv svnadmin create /srv/svn

MSG 'Configuring default user'
sudo -u svnsrv -g svnsrv echo $'[general]\npassword-db = passwd' > /srv/svn/conf/svnserve.conf
sudo -u svnsrv -g svnsrv echo $'[users]\nusersvn = passsvn' > /srv/svn/conf/passwd
