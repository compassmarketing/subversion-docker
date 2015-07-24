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
SVN_REPO=${SVN_REPO:-default}

SVN_REPO_DIR="${SVN_REPO_ROOT}/${SVN_REPO}"

MSG	'Creating default repo'
svnadmin create "${SVN_REPO_DIR}"

MSG	'Configuring default user'
echo $'[general]\npassword-db = passwd' > "${SVN_REPO_DIR}"/conf/svnserve.conf
echo $'[users]\n'"${SVN_USER}"' = '"${SVN_PASS}"$'\n' > "${SVN_REPO_DIR}"/conf/passwd

exec /usr/bin/svnserve -d --foreground --threads --root "${SVN_REPO_ROOT}"
