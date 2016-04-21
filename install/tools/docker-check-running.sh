#!/bin/bash

#	$1	Timeout

for (( i=$1; i; i-- ))
do {
	sleep 1
	svn info "svn://$HOSTNAME/$SVN_REPO" && exit 0
}
done
exit 1