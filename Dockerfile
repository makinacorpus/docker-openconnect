FROM corpusops/ubuntu:16.04
RUN \
  set -ex;revid=3;\
  for i in localsettings_pkgmgr localsettings_jdk;do \
    $COPS_ROOT/bin/cops_apply_role \
        $COPS_ROOT/roles/corpusops.roles/$i/role.yml; \
  done
#RUN \
#  set -ex;
#  apt-get update &&\
#  apt-get install -y software-properties-common
RUN \
  apt-get -y remove libicu55:amd64 &&\
  apt-get install -y \
    libproxy-dev libp11-kit-dev p11-kit p11-kit-modules \
    trousers libstoken-dev libstoken1 \
    libgnutls-dev gnutls-bin vpnc-scripts \
    libkrb5-dev libicu-dev libicu55\
    build-essential libssl-dev libxml2-dev liblz4-dev \
    libpcsclite-dev git autotools-dev m4 automake \
    automake libtool gettext liboath-dev oathtool liboath0
ADD openconnect /s/openconnect/
ADD vpnc-scripts /s/vpnc-scripts/
ADD build.sh juniper_connect.sh /s/
WORKDIR /s
RUN ./build.sh
RUN \
  /src/corpusops/corpusops.bootstrap/bin/git_pack /;\
  /sbin/cops_container_cleanup.sh;\
  /sbin/cops_container_strip.sh
CMD sh -c "exec openconnect $@"
