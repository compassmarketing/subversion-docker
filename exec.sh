#!/bin/bash

source /usr/local/include/shell-tools.shh

SVN_USER=${SVN_USER:-svnuser}
SVN_PASS=${SVN_PASS:-svnpass}
SVN_REPO=${SVN_REPO:-default}
SVN_PORT=${SVN_PORT:-3690}

SVN_REPO_DIR="${SVN_REPO_ROOT}/${SVN_REPO}"

MSG	'Enforcing SVN repo root directory permissions'
chown -R "${SVN_SRV_USER}":"${SVN_SRV_GROUP}" "${SVN_REPO_ROOT}"

MSG	'Creating default repo'
if [[ ! -d "${SVN_REPO_DIR}" ]]
then {
	sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
		svnadmin create "${SVN_REPO_DIR}" \
	|| FATAL "Cannot create REPO_DIR"

	MSG	'Configuring authentication method'
	sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
		echo $'[general]\npassword-db = passwd' > "${SVN_REPO_DIR}"/conf/svnserve.conf
}
else {
	if [[ "$(stat -c '%U:%G' "${SVN_REPO_DIR}"/conf/svnserve.conf)" != "${SVN_SRV_USER}:${SVN_SRV_GROUP}" ]]
	then FATAL 'SVN authentication file not found in repo sirectory'
	fi
}
fi

if [[ -f "${SVN_REPO_DIR}"/conf/passwd ]]
then {
	if grep -q "^${SVN_USER}" "${SVN_REPO_DIR}"/conf/passwd
	then {
		sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
			sed -e "/^${SVN_USER}/s/.*/${SVN_USER} = ${SVN_PASS}/" "${SVN_REPO_DIR}"/conf/passwd
	}
	else {
		sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
			echo "${SVN_USER}"' = '"${SVN_PASS}"$'\n' >> "${SVN_REPO_DIR}"/conf/passwd
	}
	fi
}
else {
	sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
		echo $'[users]\n'"${SVN_USER}"' = '"${SVN_PASS}"$'\n' > "${SVN_REPO_DIR}"/conf/passwd
}
fi

exec sudo -u "${SVN_SRV_USER}" -g "${SVN_SRV_GROUP}" \
	/usr/bin/svnserve -d --listen-port="${SVN_PORT}" --foreground --threads --root "${SVN_REPO_ROOT}"
exit 1
