# subversion-docker

### Build

Use `COMPASS_SOURCES_DIR` to reference the installation sources location.

### Run

svnserver does not appear to respond to any signal other than `KILL`.  So a normal container exit status is 137 (128 + 9).

An exit status of 1 likely means that svnserve failed to execute.