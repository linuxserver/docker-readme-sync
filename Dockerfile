FROM lsiobase/xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="phendryx"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV LANG="C.UTF-8"

# build packages as variable
ARG BUILD_PACKAGES="\
	apt-transport-https \
	binutils \
	bzip2 \
	cpp \
	cpp-5 \
	dh-python \
	distro-info-data \
	fontconfig-config \
	fonts-dejavu-core \
	g++ \
	g++-5 \
	gcc \
	gcc-5 \
	git \
	git-core \
	git-man \
	icu-devtools \
	libasan2 \
	libatomic1 \
	libc-dev-bin \
	libc6-dev \
	libcc1-0 \
	libcilkrts5 \
	liberror-perl \
	libexpat1 \
	libfontconfig1 \
	libfreetype6 \
	libgcc-5-dev \
	libgdbm3 \
	libgmp-dev \
	libgmpxx4ldbl \
	libgomp1 \
	libicu-dev \
	libicu55 \
	libisl15 \
	libitm1 \
	liblsan0 \
	libmpc3 \
	libmpdec2 \
	libmpfr4 \
	libmpx0 \
	libperl5.22 \
	libpng12-0 \
	libpython3-stdlib \
	libpython3.5-minimal \
	libpython3.5-stdlib \
	libquadmath0 \
	libruby2.3 \
	libstdc++-5-dev \
	libtcl8.6 \
	libtcltk-ruby \
	libtk8.6 \
	libtsan0 \
	libubsan0 \
	libx11-6 \
	libx11-data \
	libxau6 \
	libxcb1 \
	libxdmcp6 \
	libxext6 \
	libxft2 \
	libxml2 \
	libxml2-dev \
	libxrender1 \
	libxslt1-dev \
	libxslt1.1 \
	libxss1 \
	libyaml-0-2 \
	linux-libc-dev \
	lsb-release \
	make \
	mime-support \
	perl \
	perl-modules-5.22 \
	python3 \
	python3-minimal \
	python3.5 \
	python3.5-minimal \
	rake \
	ri \
	ruby \
	ruby-dev \
	ruby-did-you-mean \
	ruby-full \
	ruby-minitest \
	ruby-net-telnet \
	ruby-power-assert \
	ruby-test-unit \
	ruby2.3 \
	ruby2.3-dev \
	ruby2.3-doc \
	ruby2.3-tcltk \
	rubygems-integration \
	ucf \
	x11-common \
	zlib1g-dev"

# copy app and excludes
COPY app/ /opt/docker-readme-sync/
COPY excludes /etc/dpkg/dpkg.cfg.d/excludes

RUN \
 echo "**** install build packages ****" && \
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	$BUILD_PACKAGES && \
 curl -sL \
	https://deb.nodesource.com/setup_4.x | bash - && \
 apt-get install -y \
	--no-install-recommends \
	nodejs && \
 echo "**** install phantomjs via npm ****" && \
 npm -g install \
	phantomjs-bin && \
 install -Dm755 /usr/lib/node_modules/phantomjs-bin/bin/linux/x64/phantomjs /usr/bin/phantomjs && \
 echo "**** install ruby app gems ****" && \
 cd /opt/docker-readme-sync/ && \
 echo 'gem: --no-document' > \
	/etc/gemrc && \
 gem install bundler && \
 bundle install && \
 echo "**** uninstall build packages ****" && \
 apt-get purge -y --auto-remove \
	$BUILD_PACKAGES \
	nodejs \
	rlwrap && \
 echo "**** install runtime packages ****" && \
 apt-get install -y \
	--no-install-recommends \
	fontconfig \
	libxml2 \
	nginx-light \
	ruby && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/usr/lib/node_modules \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
 find /root -name . -o -prune -exec rm -rf -- {} + && \
 find /var/lib/gems -name "cache" -type d -exec rm -rf -- {} + && \
 mkdir -p \
	/root

# add local files
COPY root/ /

# ports and volumes
WORKDIR /opt/docker-readme-sync
EXPOSE 80 443
VOLUME /config
