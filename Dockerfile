FROM ubuntu

VOLUME /tmp/.X11-unix

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
  && apt -y install wget gnupg xvfb x11-xserver-utils python3-pip lxterminal \
  && pip3 install pyinotify \
  && echo "deb [arch=amd64] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list \
  && wget -q https://xpra.org/gpg.asc -O- | apt-key add - \
  && apt update \
  && apt install -y xpra \
  && mkdir -p /run/user/0/xpra

RUN apt -y install wget gnupg2 curl software-properties-common apt-transport-https

RUN echo 'deb http://download.opensuse.org/repositories/network:/retroshare/xUbuntu_20.04/ /' >> /etc/apt/sources.list.d/retroshare.list
RUN wget -qO - http://download.opensuse.org/repositories/network:/retroshare/xUbuntu_20.04/Release.key | apt-key add -

RUN apt-add-repository -y ppa:i2p-maintainers/i2p
RUN echo "deb [arch=amd64] https://deb.torproject.org/torproject.org $(lsb_release -sc) main" >> /etc/apt/sources.list.d/tor-project.list

RUN wget https://deb.torproject.org/torproject.org/pool/main/d/deb.torproject.org-keyring/deb.torproject.org-keyring_2020.11.18_all.deb \
  && apt -y install ./deb.torproject.org-keyring_2020.11.18_all.deb

RUN apt update && apt -y install retroshare-gui i2p tor

ENTRYPOINT ["xpra", "start", ":10000", "--bind-tcp=0.0.0.0:8080", \
  "--mdns=no", "--webcam=no", "--no-daemon", "--pulseaudio=no", \
  "--start-on-connect=lxterminal"]
