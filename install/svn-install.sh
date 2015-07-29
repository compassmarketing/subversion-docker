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

MSG	'Creating Subversion repository root'
mkdir -p "${SVN_REPO_ROOT}"
chown "${SVN_SRV_USER}":"${SVN_SRV_GROUP}" "${SVN_REPO_ROOT}"
