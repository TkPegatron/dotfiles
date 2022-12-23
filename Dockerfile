FROM alpine:latest

RUN \
  echo "**** adjust repositories and update ****" \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
  && echo "**** install runtime packages ****" \
    && apk add --no-cache --upgrade \
      apache2-utils \
      bash \
      bat \
      bind-tools \
      bird \
      bridge-utils \
      busybox-extras \
      conntrack-tools \
      curl \
      dhcping \
      direnv \
      drill \
      ethtool \
      file \
      fping \
      git \
      gpg \
      iftop \
      iperf \
      iperf3 \
      iproute2 \
      ipset \
      iptables \
      iptraf-ng \
      iputils \
      ipvsadm \
      jq \
      libc6-compat \
      liboping \
      logrotate \
      mtr \
      neovim \
      net-snmp-tools \
      netcat-openbsd \
      nftables \
      ngrep \
      nmap \
      nmap-nping \
      nmap-scripts \
      openssh-client \
      openssl \
      perl-crypt-ssleay \
      perl-net-ssleay \
      py3-pip \
      py3-setuptools \
      python3 \
      ranger \
      rsync \
      scapy \
      skim \
      socat \
      speedtest-cli \
      starship \
      stow \
      strace \
      sudo \
      swaks \
      tcpdump \
      tcptraceroute \
      tini \
      tshark \
      tzdata \
      util-linux \
      vim \
      websocat \
      zsh

#RUN useradd --create-home -s /bin/zsh elliana \
#  --comment "Elliana Perry" --home-dir /home/elliana \
#  && echo "elliana ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/elliana

# I do not like this change in paradigm
RUN adduser --ingroup wheel --ingroup users --gecos "Elliana Perry" --shell /bin/zsh --disabled-password elliana \
    && echo "elliana ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/elliana

USER elliana
WORKDIR /home/elliana
RUN pip install ansible

ENTRYPOINT ["/sbin/tini", "--"]
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
