#! /bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Updating repos'
apt-get update

MSG     'Set timezone to America/Chicago'
echo 'America/Chicago' > /etc/timezone \
&& dpkg-reconfigure --frontend noninteractive tzdata
