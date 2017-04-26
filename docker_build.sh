#!/usr/bin/env bash
[[ -n $SDEBUG ]] && set -x
vv() { echo "$@">&2;"$@"; }
die_in_error_() { if [ "x${1-$?}" != "x0" ];then echo "FAILED: $@">&2; exit 1; fi }
die_in_error() { die_in_error_ $? $@; }
# reset to well known working version
vpn_cid=a01a167b0d2f6636f15a256aa652a31cebe84b50
scripts_cid=6f87b0fe7b20d802a0747cc310217920047d58d3
cd $(dirname $0)
get_code() {
    if [[ ! -e corpusops.bootstrap ]];then
        if ! git clone https://github.com/corpusops/corpusops.bootstrap;then
            echo "cant get corpuops"
            exit 1
        fi
    else
        if ! ( cd corpusops.bootstrap && git pull; );then
            echo "cant update corpusops"
            exit 1
        fi

    fi
    if [ ! -e openconnect ];then
        vv git clone git://git.infradead.org/users/dwmw2/openconnect.git
    fi
    if [ ! -e vpnc-scripts ];then
        vv git clone git://git.infradead.org/users/dwmw2/vpnc-scripts.git
    fi
}
get_code
if [[ -n ${RELEASE-} ]];then
( cd openconnect && git reset --hard $cid ) \
    || die_in_error "openconnect $vpn_cid does not exits"
( cd vpnc-scripts && git reset --hard $cid ) \
    || die_in_error "vpnscripts: $scripts_cid does not exits"
fi
# wrapper to suash image up
corpusops.bootstrap/hacking/docker_build makinacorpus/openconnect
exit $?
# vim:set et sts=4 ts=4 tw=80:
