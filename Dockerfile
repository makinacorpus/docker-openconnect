FROM corpusops/ubuntu:20.04
RUN \
  set -ex;revid=3;\
  cd $COPS_ROOT/roles/corpusops.roles;\
  git pull;\
  apt-get update -qq
#RUN \
#  set -ex;
#  apt-get update &&\
#  apt-get install -y software-properties-common
RUN \
  apt-get -y remove libicu66:amd64 &&\
  apt-get install -y \
    libproxy-dev libp11-kit-dev p11-kit p11-kit-modules \
    openjdk-8-jdk trousers libstoken-dev libstoken1 \
    libgnutls28-dev gnutls-bin vpnc-scripts \
    libkrb5-dev libicu-dev libicu66\
    build-essential libssl-dev libxml2-dev liblz4-dev \
    libpcsclite-dev git autotools-dev m4 automake \
    automake libtool gettext liboath-dev oathtool liboath0 
RUN \
  apt-get install -y \
    zlib1g-dev
ADD openconnect /s/openconnect/
ADD vpnc-scripts /s/vpnc-scripts/
ADD build.sh juniper_connect.sh /s/
WORKDIR /s
RUN ./build.sh
RUN  apt-get install -y openfortivpn
RUN \
  /src/corpusops/corpusops.bootstrap/bin/git_pack /;\
  /sbin/cops_container_cleanup.sh;\
  /sbin/cops_container_strip.sh
CMD sh -c "exec openconnect $@"
