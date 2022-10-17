FROM ghcr.io/linuxserver/baseimage-alpine:3.16

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="phendryx"

ENV S6_KEEP_ENV=1

# copy app
COPY ./root /

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    nodejs && \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    npm && \
  echo "**** install readme-sync node packages *****" && \
  npm config set unsafe-perm true && \
  npm install --prefix /opt/docker-readme-sync && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root \
    /tmp/* && \
  mkdir -p \
    /root

WORKDIR /opt/docker-readme-sync
