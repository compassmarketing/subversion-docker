#! /bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Cleaning up'
apt-get -y clean
rm -rf	/var/lib/apt/lists/* \
	/tmp/* \
	/var/tmp/*
MSG	'DONE'
