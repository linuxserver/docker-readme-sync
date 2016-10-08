docker build -t github-dockerhub-sync .
docker run -d --name github-dockerhub-sync -v /Users/phendryx/Code/me/docker-github-dockerhub-sync/tmp/config:/config -p 80:80 github-dockerhub-sync
