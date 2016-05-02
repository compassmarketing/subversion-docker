#!/bin/bash

#	$1	Timeout
#	$2	Check interval

source /usr/local/include/shell-tools.shh

waittime=${1:-300}
waitinterval=${2:-2}

checks=$(n_of_checks ${waittime} ${waitinterval})

for (( i=${checks}; i; i-- ))
do {
	sleep ${waitinterval}

	svn info "svn://$HOSTNAME/$SVN_REPO" \
	&& exit 0
}
done
exit 1