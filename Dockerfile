FROM alpine:3.5
MAINTAINER Albert Dixon <albert@dixon.rocks>

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/bin/start-cmd"]
ENV TINI_VERSION=v0.13.2 \
    SABNZB_VERSION=1.2.0 \
    SIGIL_VERSION=0.4.0

RUN apk add --update --no-cache --purge \
      autoconf \
      automake \
      ca-certificates \
      curl \
      g++ \
      gcc \
      libffi-dev \
      make \
      openssl-dev \
      openvpn \
      python \
      python-dev \
      p7zip \
      tar \
      tini \
      unrar \
      unzip \

    # Install par2cmdline
    && curl -s -o par2.zip https://github.com/Parchive/par2cmdline/archive/master.zip \
    && unzip par2 \
    && cd par2cmdline-master \
    && aclocal && automake --add-missing && autoconf \
    && ./configure && make && make install && cd .. \
    && rm -rvf par2* \

    # Install python deps
    && curl -s https://bootstrap.pypa.io/get-pip.py | python \
    && pip install -U pip \
    && pip install -U \
        cheetah \
        pip \
        pyopenssl \
        supervisor \
    && pip install http://www.golug.it/pub/yenc/yenc-0.4.0.tar.gz \

    && curl -s -o /sigil.tgz https://github.com/gliderlabs/sigil/releases/download/v$SIGIL_VERSION/sigil_${SIGIL_VERSION}_Linux_x86_64.tgz
    && curl -s -o /sabnzb.tgz https://github.com/sabnzbd/sabnzbd/releases/download/$SABNZB_VERSION/SABnzbd-$SABNZB_VERSION-src.tar.gz
    && mkdir -pv /usr/src/app \
    && tar xvzf sigil.tgz -C /usr/local/bin \
    && tar xvzf sabnzb.tgz -C /usr/src/app \
    && rm -rvf *.tgz \
    
    # Clean up
    && apk del --purge \
        gcc \
        autoconf \
        automake \
        git \
        g++ \
        make \
        python-dev \
        openssl-dev \
        libffi-dev \
    && rm -rvf /var/cache/apk/* /tmp/* /var/tmp/*

COPY start-cmd /bin/
COPY config /config
