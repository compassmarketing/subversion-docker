#! /bin/bash

MSG() {
        echo "=== $1"
}

ERROR() {
        echo "--- $1"
        exit 1
}

MSG	'Install Subversion'
DEBIAN_FRONTEND=noninteractive apt-get install -y subversion

MSG	'Adding Subversion server user and group'
adduser --system --shell /usr/sbin/nologin --no-create-home --disabled-login "${SVN_SRV_USER}"
addgroup --system "${SVN_SRV_GROUP}"
adduser "${SVN_SRV_USER}" "${SVN_SRV_GROUP}"

MSG	'Creating Subversion repo'
mkdir -p "${SVN_REPO_DIR}"
chown "${SVN_SRV_USER}":"${SVN_SRV_GROUP}" "${SVN_REPO_DIR}"
sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" svnadmin create "${SVN_REPO_DIR}"
