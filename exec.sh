#!/bin/bash

source /usr/local/include/shell-tools.shh

MSG	'Setting defaults for environment variables'
SVN_USER=${SVN_USER:-svnuser}
SVN_PASS=${SVN_PASS:-svnpass}
SVN_REPO=${SVN_REPO:-default}
SVN_PORT=${SVN_PORT:-3690}

SVN_REPO_DIR="${SVN_REPO_ROOT}/${SVN_REPO}"

INFO	'Environment'
INFO
INFO	"SVN_USER = ${SVN_USER}"
INFO	"SVN_PASS = ${SVN_PASS}"
INFO	"SVN_REPO = ${SVN_REPO}"
INFO	"SVN_PORT = ${SVN_PORT}"
INFO
INFO	"SVN_REPO_DIR = ${SVN_REPO_DIR}"

MSG	'Enforcing SVN repo root directory permissions'
chown -R "${SVN_SRV_USER}":"${SVN_SRV_GROUP}" "${SVN_REPO_ROOT}"

if [[ ! -d "${SVN_REPO_DIR}" ]]
then {
	MSG	"Creating default repo: ${SVN_REPO}"
	sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
		svnadmin create "${SVN_REPO_DIR}" \
	|| FATAL "Cannot create REPO_DIR: ${SVN_REPO_DIR}"

	MSG	'Configuring authentication method'
	sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
		echo $'[general]\npassword-db = passwd' > "${SVN_REPO_DIR}"/conf/svnserve.conf \
	|| FATAL "Cannot create configuration file '${SVN_REPO_DIR}/conf/svnserve.conf'"
}
else {
	MSG	"Reusing existing default repo: ${SVN_REPO}"
	if [[ "$(stat -c '%U:%G' "${SVN_REPO_DIR}"/conf/svnserve.conf)" != "${SVN_SRV_USER}:${SVN_SRV_GROUP}" ]]
	then FATAL "SVN authentication file not found in repo directory '${SVN_REPO_DIR}', or permission denied to SVN user '${SVN_SRV_USER}'"
	fi
}
fi

if [[ -f "${SVN_REPO_DIR}"/conf/passwd ]]
then {
	MSG	"Updating username and password for SVN user '${SVN_USER}'"

	if grep -q "^${SVN_USER}" "${SVN_REPO_DIR}"/conf/passwd
	then {
		MSG	"Setting password for user '${SVN_USER}'"
		sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
			sed -e "/^${SVN_USER}/s/.*/${SVN_USER} = ${SVN_PASS}/" "${SVN_REPO_DIR}"/conf/passwd \
		|| FATAL "Failed to set password for user '${SVN_USER}'"
	}
	else {
		MSG	"Creating a new password for user '${SVN_USER}'"
		sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
			echo "${SVN_USER}"' = '"${SVN_PASS}"$'\n' >> "${SVN_REPO_DIR}"/conf/passwd \
		|| FATAL "Failed to create a new password for user '${SVN_USER}'"
	}
	fi
}
else {
	MSG	'Creating new passwd file for default repo'
	sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
		echo $'[users]\n'"${SVN_USER}"' = '"${SVN_PASS}"$'\n' > "${SVN_REPO_DIR}"/conf/passwd \
	|| FATAL 'Failed to create a new passwd file for default repo'
}
fi

MSG	'Starting SVN server'
exec sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
	/usr/bin/svnserve -d --listen-port="${SVN_PORT}" --foreground --threads --root "${SVN_REPO_ROOT}"

FATAL 'Failed to start server'
