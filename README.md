# subversion-docker

### Dockerfile

##### Variables

`DOCKER_UID`
  - Docker unprivileged user system ID.  *Poorly documented, may become obsolete*

`DOCKER_GID`
  - Docker unprivileged user system ID.  *Poorly documented, may become obsolete*

`COMPASS_SOURCES_DIR`
  - Location where the sources will be copied.

`SVN_REPO_ROOT`="/srv/svn" \
  - Location of the SVN repository root

`SVN_SRV_USER`
  - SVN unprivileged user

`SVN_SRV_GROUP`
  - SVN unprivileged group


##### Scripts

`${COMPASS_SOURCES_DIR}/ubuntu-begin.sh`
  - Ubuntu setup wrapper

`${COMPASS_SOURCES_DIR}/svn-install.sh`
  - SVN main installation script.

`${COMPASS_SOURCES_DIR}/centos-end.sh`
  - Ubuntu cleanup wrapper


### Build

```console
docker build -t compassventures/subversion .
```

### Run

1. Start the container:

  ```console
  docker run -d --net=host --name=js <host volumes> <variables> compassventures/subversion
  ```

  - Attach host volumes with:<br />
    `--volume=/host-mountpoint:/container-mountpoint`

  The following variables configure the container:

  Variable | Description | Notes
  -------- | ----------- | -----
  `SVN_USER` | Client username | **Required** <br /> Default is *svnuser*
  `SVN_PASS` | Client Password | **Required** <br /> Default is *svnpass*
  `SVN_REPO` | Repository name (inside the repository root) | **Required** <br /> Default is *default*
  `SVN_PORT` | Server Port | **Use default** <br /> Default is *3690*

> svnserver does not appear to respond to any signal other than `KILL`.  So a normal container exit status is **137** (128 + 9).

> An exit status of 1 likely means that svnserve failed to execute.
