# subversion-docker

### Build

Build the container normally.  For example:

```console
docker build -t compassventures/subversion .
```

##### Dockerfile Variables

Variable | Description | Notes
-------- | ----------- | -----
`DOCKER_UID` | Docker unprivileged user system ID. | *Poorly documented by Docker, may become obsolete*
`DOCKER_GID` | Docker unprivileged user system ID. | *Poorly documented by Docker, may become obsolete*
`COMPASS_SOURCES_DIR` | Location where the sources will be copied during install. |
`SVN_REPO_ROOT` | SVN repository root directory |
`SVN_SRV_USER` | SVN server unprivileged user |
`SVN_SRV_GROUP` | SVN server unprivileged group |

##### Dockerfile Scripts

Script | Description | Notes
-------- | ----------- | -----
`${COMPASS_SOURCES_DIR}/ubuntu-begin.sh` | Ubuntu setup wrapper | Shared with other Ubuntu containers
`${COMPASS_SOURCES_DIR}/svn-install.sh` | SVN main installation script |
`${COMPASS_SOURCES_DIR}/centos-end.sh` | Ubuntu cleanup wrapper | Shared with other Ubuntu containers

### Run

Start the container normally.  For example:

```console
docker run -d --net=host --name=js <host volumes> <variables> compassventures/subversion
```

##### Volumes

The container exposes the SVN root directory (`${SVN_REPO_ROOT}`) as a volume.

##### Environment Variables

The following variables configure the container:

Variable | Description | Notes
-------- | ----------- | -----
`SVN_USER` | Client username | **Required** <br /> Default is *svnuser*
`SVN_PASS` | Client Password | **Required** <br /> Default is *svnpass*
`SVN_REPO` | Repository name (inside the repository root) | **Required** <br /> Default is *default*
`SVN_PORT` | Server Port | **Use default** <br /> Default is *3690*

##### Helper scripts

Helper scripts are usually invoked with `docker exec` for specific functions

Syntax | Description
------ | -----------
`< required >` | Required parameter
`[ optional ]` | Optional parameter

- `check-running.sh [ timeout [interval] ]`

  Tests if the container's processes have finished initializing.

  - `timeout` - Timeout to wait before returning a failure
  - `interval` - Interval between state checks

### Notes

- svnserver does not appear to respond to any signal other than `KILL`.  So a normal container exit status is **137** (128 + 9).
- An exit status of 1 likely means that svnserve failed to execute.
