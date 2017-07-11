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
[![](https://images.microbadger.com/badges/version/lsiodev/readme-sync.svg)](https://microbadger.com/images/lsiodev/readme-sync "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/lsiodev/readme-sync.svg)](https://microbadger.com/images/lsiodev/readme-sync "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/lsiodev/readme-sync.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/lsiodev/readme-sync.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Tools/readme-sync-docker)](https://ci.linuxserver.io/job/Tools/job/readme-sync-docker/)

Utility to copy README.md from a given github.com repository to a given dockerhub.com repository. 

## Usage

```
docker create \
--name=readme-sync \
-e PUID=<UID> \
-e PGID=<GID> \
-p 80:80 \
-v </path/to/appdata>:/config \
lsiodev/readme-sync
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 80` - API Port
* `-v /config` - Contains the db itself and all assorted settings. 
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on ubuntu xenial with s6 overlay, for shell access whilst the container is running do `docker exec -it readme-sync /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work".

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 

Once the docker container is created, an example settings file will be copied to `</path/to/appdata>/github-dockerhub-sync/settings.yml`. This file should be modified to contain your Dockerhub email and password.


## Using the application

In the examples below, `github_repo` and `dockerhub_repo` should look similar `lsiodev/readme-sync.`

### API - GET command

`http://<ip_address>:<port>/description/update?github_repo=<github_repo>&dockerhub_repo=<dockerhub_repo>`

### Command Line

In the example below, the application would take the README.me found at the 
`my_github/my_repo` repo and save it on the 
`my_dockerhub/my_repo` dockerhub repo's full description field. 

NOTE: The `[` and `]` are important and must be in the command line.

`docker exec -it readme-sync bash -c "rake update[my_github/my_repo,my_dockerhub/my_repo]"`

### Command Line with ENV variables

`docker exec -it readme-sync bash -c "rake update" USE_ENV_CREDENTIALS=true  DOCKERHUB_USERNAME=<username> DOCKERHUB_PASSWORD=<password> GIT_REPOSITORY=<GIT_REPOSITORY> DOCKER_REPOSITORY=<DOCKER_REPOSITORY>`

## Info

* Shell access whilst the container is running: `docker exec -it readme-sync /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f readme-sync`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' readme-sync`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' lsiodev/readme-sync`

## Versions

+ **16.10.16:** merge ruby app.
+ **11.10.16:** Initial development release.

