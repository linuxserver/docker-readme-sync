FROM lsiobase/xenial
MAINTAINER phendryx

# install packages
RUN apt-get update && apt-get -y install \
    build-essential \
    gcc \
    git \
    libffi-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    nginx \
    nodejs \
    nodejs-legacy \
    npm \
    ruby \
    ruby-dev \
    ruby-full \
    zlib1g \
    zlib1g-dev \
    zlibc

# dirty hack below, installing phantomjs via npm. The phantomjs build for ubuntu 16.04,
# as of 2016-10-08, does not work headless, which defeats the purpose of phantomjs.

# install github-dockerhub-sync
RUN npm -g install phantomjs-prebuilt \
    && echo 'gem: --no-document' > /etc/gemrc \
    && git clone https://github.com/phendryx/github-dockerhub-sync.git /opt/github-dockerhub-sync/ \
    && cd /opt/github-dockerhub-sync \
    && gem install bundler \
    && bundle install

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
