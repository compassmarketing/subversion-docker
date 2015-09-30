#! /bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Install Subversion'
DEBIAN_FRONTEND=noninteractive apt-get install -y subversion

MSG	'Installing Compass Tools'
chmod 644 ${COMPASS_SOURCES_DIR}/include/*
cp ${COMPASS_SOURCES_DIR}/include/* /usr/local/include/

MSG	'Adding Subversion server user and group'
adduser --system --shell /usr/sbin/nologin --no-create-home --disabled-login "${SVN_SRV_USER}"
addgroup --system "${SVN_SRV_GROUP}"
adduser "${SVN_SRV_USER}" "${SVN_SRV_GROUP}"

MSG	'Creating Subversion repository root'
mkdir -p "${SVN_REPO_ROOT}"
chown "${SVN_SRV_USER}":"${SVN_SRV_GROUP}" "${SVN_REPO_ROOT}"
