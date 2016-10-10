FROM lsiobase/xenial
MAINTAINER phendryx

# package version
ARG PHANTOM_VER="2.1.13"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# build packages as variable
ARG BUILD_PACKAGES="\
	g++ \
	gcc \
	git-core \
	libxml2-dev \
	libxslt1-dev \
	make \
	ruby-dev \
	ruby-full \
	zlib1g-dev"

# install runtime packages
RUN \
 apt-get update && \
 apt-get -y install \
	bzip2 \
	curl \
	fontconfig \
	libffi-dev \
	libxml2 \
	nginx \
	ruby \
	zlib1g \
	zlibc && \

# install build packages
 apt-get install -y \
	$BUILD_PACKAGES && \

# install phantomjs
 mkdir -p \
	/tmp/phantom-src && \
 curl -o \
 /tmp/phantom.tar.gz -L \
	"https://github.com/Medium/phantomjs/archive/${PHANTOM_VER}.tar.gz" && \
 tar xf \
 /tmp/phantom.tar.gz -C \
	/tmp/phantom-src --strip-components=1 && \
 cp /tmp/phantom-src/bin/* /usr/bin/ && \

# install github-dockerhub-sync
 git clone https://github.com/phendryx/github-dockerhub-sync.git \
	/opt/github-dockerhub-sync/ && \
 cd /opt/github-dockerhub-sync && \
 echo 'gem: --no-document' > \
	/etc/gemrc && \
 gem install bundler && \
 bundle install && \

# clean up
 apt-get purge -y --auto-remove \
	$BUILD_PACKAGES && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
 find /root -name . -o -prune -exec rm -rf -- {} +


# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
