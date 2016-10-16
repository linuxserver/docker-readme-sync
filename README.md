
# WORK IN PROGRESS, DO NOT USE!!! #


## Usage

```
docker create \
--name=github-dockerhub-sync \
-v <path to data>:/config \
-e PGID=<gid> -e PUID=<uid> \
-p 80:80 \
phendryx/github-dockerhub-sync
```

## Config

After installing, edit <path to data>/github-dockerhub-sync/settings.yml and 
enter your Dockerhub email/password.

## Sync Readme

Replace my repos with your repos.

Hit 
```
http://<ip>:<port>/description/update?github_repo=phendryx/docker-github-dockerhub-sync&dockerhub_repo=phendryx/github-dockerhub-sync
```
