#!/bin/bash

MSG() {
        echo "=== $1"
}

ERROR() {
        echo "--- $1"
        exit 1
}

SVN_USER=${SVN_USER:-svnuser}
SVN_PASS=${SVN_PASS:-svnpass}

MSG	'Configuring default user'
echo $'[general]\npassword-db = passwd' > /srv/svn/conf/svnserve.conf
echo $'[users]\n'"${SVN_USER}"' = '"${SVN_PASS}"$'\n' > /srv/svn/conf/passwd

exec /usr/bin/svnserve -d --foreground --threads --root "${SVN_REPO_DIR}"
