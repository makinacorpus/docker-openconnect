#!/usr/bin/env bash
set -ex
vv() { echo "$@">&2;"$@"; }
die_in_error_() { if [ "x${1-$?}" != "x0" ];then echo "FAILED: $@">&2; exit 1; fi }
die_in_error() { die_in_error_ $? $@; }
cd $(dirname $0)
W=$(pwd)
PREFIX=/usr/local
cd openconnect
vv ./autogen.sh
die_in_error openconnect autogen
export LDFLAGS="-Wl,-rpath,$PREFIX/lib"
if [ ! -e /usr/lib/libpskc.so ];then
    ln /usr/lib/liboath.so /usr/lib/libpskc.so
    die_in_error pskc lib
fi
if [ ! -e /usr/lib/pkgconfig/liboath.pc ];then
    cp /usr/lib/pkgconfig/liboath.pc \
        /usr/lib/pkgconfig/libpskc.pc &&\
        sed -i -re "s/oath/pskc/g"
    /usr/lib/pkgconfig/liboath.pc
    die_in_error pskc pkgconfig
fi
if [ ! -e /usr/include/pskc/pskc.h ];then
    mkdir /usr/include/pskc &&\
        cp /usr/include/liboath/oath.h \
        /usr/include/pskc/pskc.h
    die_in_error pskc include
fi
vv ./configure \
    --with-libpskc \
    --with-java \
    --with-java \
    --with-vpnc-script=$W/vpnc-scripts/vpnc-script \
    && vv make && vv make install
# vim:set et sts=4 ts=4 tw=80:
