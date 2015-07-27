#! /bin/bash

MSG() {
        echo "=== $1"
}

ERROR() {
        echo "--- $1"
        exit 1
}

MSG	'Updating repos'
apt-get update

MSG     'Set timezone to America/Chicago'
echo 'America/Chicago' > /etc/timezone \
&& dpkg-reconfigure --frontend noninteractive tzdata
