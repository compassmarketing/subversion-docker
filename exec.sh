#!/bin/bash

source /usr/local/include/shell-tools.shh

SVN_USER=${SVN_USER:-svnuser}
SVN_PASS=${SVN_PASS:-svnpass}
SVN_REPO=${SVN_REPO:-default}
SVN_PORT=${SVN_PORT:-3690}

SVN_REPO_DIR="${SVN_REPO_ROOT}/${SVN_REPO}"

MSG	'Creating default repo'
svnadmin create "${SVN_REPO_DIR}"

MSG	'Configuring default user'
echo $'[general]\npassword-db = passwd' > "${SVN_REPO_DIR}"/conf/svnserve.conf
echo $'[users]\n'"${SVN_USER}"' = '"${SVN_PASS}"$'\n' > "${SVN_REPO_DIR}"/conf/passwd

exec /usr/bin/svnserve -d --listen-port="${SVN_PORT}" --foreground --threads --root "${SVN_REPO_ROOT}"
exit 1
