#!/usr/bin/env bash
cd $(dirname $0)
def() {
    echo define envvar: $1
    exit 1
}
TEMPO=${TEMPO:-15}
DEBUG=${DEBUG-}
OPENFORTIFLAGS="${OPENFORTIFLAGS-}"
if [[ -n $DEBUG ]];then
    set -x
    OPENFORTIFLAGS="-vvvvv"
fi

[[ -f env.sh ]] && . env.sh
cnf=/conf
echo > $cnf
if [[ -n "$VPN_PASSWORD" ]];then
    echo "password=$VPN_PASSWORD">>$cnf
fi
if [[ -n "$VPN_HOST" ]];then
    echo "host=$VPN_HOST">>$cnf
fi
if [[ -n "$VPN_PORT" ]];then
    echo "port=$VPN_PORT">>$cnf
fi
if [[ -n "$VPN_REALM" ]];then
    echo "realm=$VPN_REALM">>$cnf
fi
if [[ -n "$VPN_USER" ]];then
    echo "username=$VPN_USER">>$cnf
fi
touch /olog
( LANG=C LC_ALL=C \
    openfortivpn $OPENFORTIFLAGS -c $cnf 2>&1 > /olog; )&
( tail -f /olog )&
ret=1
for i in $(seq $TEMPO);do
    sleep $i
    if ( grep -q "Tunnel is up and running" /olog );then
        ret=0
        break
    fi
done
if [[ $ret != 0 ]];then
    echo "Failed to bring up VPN"
else
    echo
    echo Launching shell
    echo
    bash
    ret=$?
fi
exit $ret
# vim:set et sts=4 ts=4 tw=80:
