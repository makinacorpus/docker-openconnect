FROM ubuntu:16.04
RUN \
  apt-get update &&\
  apt-get install -y software-properties-common
RUN \
  apt-get install -y \
    libproxy-dev libp11-kit-dev p11-kit p11-kit-modules \
    trousers libstoken-dev libstoken1 \
    libgnutls-dev gnutls-bin vpnc-scripts \
    libkrb5-dev \
    build-essential libssl-dev libxml2-dev liblz4-dev \
    libpcsclite-dev git autotools-dev m4 automake \
    automake libtool gettext liboath-dev
RUN \
  add-apt-repository -u -y ppa:webupd8team/java &&\
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true"\
  | debconf-set-selections &&\
  apt-get install -y \
    oracle-java8-installer oracle-java8-set-default
RUN apt-get install -y oathtool liboath0
ADD openconnect /s/openconnect/
ADD vpnc-scripts /s/vpnc-scripts/
ADD build.sh /s/
WORKDIR /s
RUN ./build.sh
ADD juniper_connect.sh /s/
RUN  \
  rm -rvf /var/lib/apt/lists/* \
     $(find /var/cache -name '*deb') \
     $(find /var/cache/oracle* -name '*.tar.*')
CMD sh -c "exec openconnect $@"
