FROM resin/rpi-raspbian:latest  
ENTRYPOINT []

RUN apt-get update && apt-get install -y \
	libnss-mdns \
	gcc \
	pkg-config \
	net-tools git \
	libao-dev \
	libssl-dev \
	make \
	vim \
        libcrypt-openssl-rsa-perl \
	libio-socket-inet6-perl \
	libwww-perl \
	avahi-utils
	
RUN cd /tmp && \
	git clone https://github.com/albertz/shairport.git shairport && \
	cd shairport && \
	make && \
	make install

RUN perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit' && \
	cpan install Net::SDP

RUN mkdir -p /var/run/avahi-daemon
VOLUME /var/run/avahi-daemon

WORKDIR /app

ADD . /app

CMD ["./bla.sh"]
