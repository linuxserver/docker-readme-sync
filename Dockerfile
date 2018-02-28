FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="phendryx"

# copy app
COPY ./ /opt/docker-readme-sync/

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	nodejs-npm && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	nodejs && \
 echo "**** install readme-sync node packages *****" && \
 cd /opt/docker-readme-sync && \
 npm install && \
 echo "**** cleanup ****" && \
 rm -rf \
	/root \
	/tmp/* && \
 mkdir -p \
	/root

WORKDIR /opt/docker-readme-sync
