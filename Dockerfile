FROM alpine:3.7

ENV SEARX_VER="0.14.0"

RUN apk add -U --virtual deps gcc g++ make \
		py2-pip python2-dev libxml2-dev libxslt-dev \
		libffi-dev libressl libressl-dev && \
	mkdir /opt && \
	cd /opt && \
	wget https://github.com/asciimoo/searx/archive/v$SEARX_VER.tar.gz && \
	tar xf v$SEARX_VER.tar.gz && \
	ln -s /opt/searx-$SEARX_VER/ searx && \
	cd /opt/searx-$SEARX_VER/ && \
	./manage.sh update_packages && \
	sed -i -e "s/ultrasecretkey/`openssl rand -hex 16`/g" searx/settings.yml && \
	sed -i '0,/127.0.0.1/! s/127.0.0.1/0.0.0.0/' searx/settings.yml && \
	apk del --purge deps && \
	apk add python2 libxslt && \
	rm -rf /opt/v$SEARX_VER.tar.gz
