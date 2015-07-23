FROM ubuntu:14.04

COPY	install	/root/install

RUN	/root/install/ubuntu-begin.sh \
	&& /root/install/svn-install.sh \
	&& /root/install/ubuntu-end.sh

EXPOSE	3690
USER	svnsrv
ENTRYPOINT	[ "/usr/bin/svnserve", "-d", "--foreground", "--threads", "--root", "/srv/svn" ]
