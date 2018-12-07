FROM	ubuntu:16.04

ENV	\
	DOCKER_UID=499 \
	DOCKER_GID=499 \
	COMPASS_SOURCES_DIR="/root/install" \
	SVN_REPO_ROOT="/srv/svn" \
	SVN_SRV_USER="svnsrv" \
	SVN_SRV_GROUP="svnsrv"

COPY	install	${COMPASS_SOURCES_DIR}

RUN	${COMPASS_SOURCES_DIR}/ubuntu-begin.sh \
	&& ${COMPASS_SOURCES_DIR}/svn-install.sh \
	&& ${COMPASS_SOURCES_DIR}/ubuntu-end.sh

COPY	exec.sh	/etc/init.d/

VOLUME	${SVN_REPO_ROOT}

EXPOSE	3690
# USER	${SVN_SRV_USER}
ENTRYPOINT	["/etc/init.d/exec.sh"]
