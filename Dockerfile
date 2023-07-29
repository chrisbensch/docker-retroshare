FROM chrisbensch/docker-debian-xrdp:latest

ENV DEBIAN_FRONTEND noninteractive

# Add RetroShare Repo
RUN echo 'deb http://download.opensuse.org/repositories/network:/retroshare/Debian_Testing/ /' >> /etc/apt/sources.list.d/retroshare.list

RUN wget -qO - http://download.opensuse.org/repositories/network:/retroshare/Debian_Testing/Release.key | apt-key add -

# Add I2P Repo
RUN echo "deb [signed-by=/usr/share/keyrings/i2p-archive-keyring.gpg] https://deb.i2p2.de/ $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/i2p.list && \
  curl -o i2p-archive-keyring.gpg https://geti2p.net/_static/i2p-archive-keyring.gpg && \
  cp i2p-archive-keyring.gpg /usr/share/keyrings && \
  ln -sf /usr/share/keyrings/i2p-archive-keyring.gpg /etc/apt/trusted.gpg.d/i2p-archive-keyring.gpg

# Add Tor & TorBrowser-Launcher Repos
RUN echo "deb [arch=amd64] https://deb.torproject.org/torproject.org $(lsb_release -sc) main" >> /etc/apt/sources.list.d/tor-project.list

RUN wget https://deb.torproject.org/torproject.org/pool/main/d/deb.torproject.org-keyring/deb.torproject.org-keyring_2022.04.27.1_all.deb && \
    apt-get -y install ./deb.torproject.org-keyring_2022.04.27.1_all.deb

RUN echo "deb http://deb.debian.org/debian bullseye-backports main contrib" >> /etc/apt/sources.list.d/bullseye.list

# Install Software 
RUN apt-get update && \
    apt-get -y install \
    openjdk-17-jre \
    retroshare-gui \
    i2p \
    i2p-keyring \
    tor \
    torsocks \
    obfs4proxy \
    tor-geoipdb \
    torbrowser-launcher && \
    useradd --create-home -d /home/i2p --shell /bin/bash i2p

COPY ./build/ubuntu-run.sh /usr/bin/
RUN mv /usr/bin/ubuntu-run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

#RUN apt -y autoremove \
#  && apt -y autoclean \
#  && rm -rf /var/lib/apt/lists/*
