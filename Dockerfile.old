FROM chrisbensch/docker-ubuntu-vnc:xfce4

VOLUME /tmp/.X11-unix

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
  && apt -y dist-upgrade \
  && apt -y install wget gnupg2 curl software-properties-common apt-transport-https

RUN echo 'deb http://download.opensuse.org/repositories/network:/retroshare/xUbuntu_20.04/ /' >> /etc/apt/sources.list.d/retroshare.list
RUN wget -qO - http://download.opensuse.org/repositories/network:/retroshare/xUbuntu_20.04/Release.key | apt-key add -

RUN apt-add-repository -y ppa:i2p-maintainers/i2p
RUN echo "deb [arch=amd64] https://deb.torproject.org/torproject.org $(lsb_release -sc) main" >> /etc/apt/sources.list.d/tor-project.list

RUN wget https://deb.torproject.org/torproject.org/pool/main/d/deb.torproject.org-keyring/deb.torproject.org-keyring_2020.11.18_all.deb \
  && apt -y install ./deb.torproject.org-keyring_2020.11.18_all.deb

RUN apt update && apt -y install retroshare-gui i2p tor torsocks obfs4proxy tor-geoipdb torbrowser-launcher privoxy hexchat

# Just to squash error message during startup - temporary
RUN mkdir -p /root/.config

COPY privoxy.config /etc/privoxy/config
COPY tor-supervisor.conf /etc/supervisor/conf.d/tor-supervisor.conf
COPY i2p-supervisor.conf /etc/supervisor/conf.d/i2p-supervisor.conf

RUN apt -y autoremove \
  && apt -y autoclean \
  && rm -rf /var/lib/apt/lists/*
