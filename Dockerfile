FROM lsiobase/xenial
MAINTAINER phendryx

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# build packages as variable
ARG BUILD_PACKAGES="\
    g++ \
    gcc \
    git-core \
    libxml2-dev \
    libxslt1-dev \
    make \
    npm \
    ruby-dev \
    ruby-full \
    zlib1g-dev"

COPY app/ /opt/docker-readme-sync/

# install runtime packages
RUN \
 apt-get update && \
 apt-get -y install \
    libffi-dev \
    libxml2 \
    nginx \
    nodejs \
    nodejs-legacy \
    ruby \
    zlib1g \
    zlibc && \

# install build packages
 apt-get install -y \
    $BUILD_PACKAGES && \

# dirty hack below, installing phantomjs via npm. The phantomjs build for ubuntu 16.04,
# as of 2016-10-08, does not work headless, which defeats the purpose of phantomjs.
 npm -g install \
    phantomjs-prebuilt && \

# install ruby app gems
 cd /opt/docker-readme-sync/ && \
 echo 'gem: --no-document' > \
    /etc/gemrc && \
 gem install bundler && \
 bundle install && \

# clean up
 apt-get purge -y --auto-remove \
    $BUILD_PACKAGES && \
 rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* && \
 find /root -name . -o -prune -exec rm -rf -- {} +


# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config