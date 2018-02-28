[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
 [hub]: https://hub.docker.com/r/lsiodev/readme-sync/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# lsiodev/readme-sync
[![](https://images.microbadger.com/badges/version/lsiodev/readme-sync.svg)](https://microbadger.com/images/lsiodev/readme-sync "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/lsiodev/readme-sync.svg)](https://microbadger.com/images/lsiodev/readme-sync "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/lsiodev/readme-sync.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/lsiodev/readme-sync.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/lsiodev/readme-sync-docker)](https://ci.linuxserver.io/job/Docker-Builders/job/lsiodev/job/readme-sync-docker/)

Utility to copy README.md from a given github.com repository to a given dockerhub.com repository. 

## Usage

```
docker run --rm=true \
    -e DOCKERHUB_USERNAME=<USERNAME> \
    -e DOCKERHUB_PASSWORD=<PASSWORD> \
    -e GIT_REPOSITORY=<GITHUB REPO> \
    -e DOCKER_REPOSITORY=<DOCKERHUB REPO> \
    -e GIT_BRANCH=<GITHUB BRANCH> \
    lsiodev/readme-sync bash -c 'cd /opt/docker-readme-sync; node sync'
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-e DOCKERHUB_USERNAME` - your dockerhub username
* `-e DOCKERHUB_PASSWORD` - your dockerhub password
* `-e GIT_REPOSITORY` - github repository, i.e. linuxserver/docker-readme-sync
* `-e DOCKER_REPOSITORY` - dockerhub repository, i.e. lsiodev/docker-readme-sync
* `-e GIT_BRANCH` - github repository branch, optional (default: master)

It is based on alpine and is not meant to run as a service. The sync is performed and the command exits.

## Versions

+ **28.02.18:** convert repo to use node.js implementation.
+ **17.11.08:** add github branch support.
+ **16.10.16:** merge ruby app.
+ **11.10.16:** Initial development release.

