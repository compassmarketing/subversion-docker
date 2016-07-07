#! /bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Installing Subversion and netcat'
DEBIAN_FRONTEND=noninteractive apt-get install -y subversion \
	netcat

MSG	'Installing Compass Tools'
chmod 644 ${COMPASS_SOURCES_DIR}/include/*
cp ${COMPASS_SOURCES_DIR}/include/* /usr/local/include/

chmod 755 ${COMPASS_SOURCES_DIR}/bin/*
cp ${COMPASS_SOURCES_DIR}/bin/* /usr/local/bin/

MSG	'Adding Subversion server user and group'
addgroup --system --gid "${DOCKER_GID}" "${SVN_SRV_GROUP}"
adduser --system --uid "${DOCKER_UID}" --shell /usr/sbin/nologin --no-create-home --disabled-login --ingroup "${SVN_SRV_GROUP}" "${SVN_SRV_USER}"

MSG	'Creating Subversion repository root'
mkdir -p "${SVN_REPO_ROOT}"
