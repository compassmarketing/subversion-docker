FROM ubuntu:14.04

ENV	SVN_REPO_DIR="/srv/svn" \
	SVN_SRV_USER="svnsrv" \
	SVN_SRV_GROUP="svnsrv"

COPY	install	/root/install

RUN	/root/install/ubuntu-begin.sh \
	&& /root/install/svn-install.sh \
	&& /root/install/ubuntu-end.sh

COPY	exec.sh	/etc/init.d/

EXPOSE	3690
USER	${SVN_SRV_USER}
ENTRYPOINT ["/etc/init.d/exec.sh"]
