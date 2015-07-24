#! /bin/bash

MSG() {
        echo "=== $1"
}

ERROR() {
        echo "--- $1"
        exit 1
}

MSG	'Cleaning up'
apt-get -y clean
rm -rf	/var/lib/apt/lists/* \
	/tmp/* \
	/var/tmp/*
MSG	'DONE'
