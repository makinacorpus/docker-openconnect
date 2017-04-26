#!/usr/bin/env bash
cd $(dirname $0)
def() {
    echo define envvar: $1
    exit 1
}
[[ -f env.sh ]] && . env.sh
[[ -z "$VPN_PASSWORD" ]] && def VPN_PASSWORD
[[ -z "$VPN_URL" ]]  && def VPN_URL
[[ -z "$VPN_REALM" ]] && def VPN_REALM
[[ -z "$VPN_USER" ]]  && def VPN_USER
echo "$VPN_PASSWORD" | \
    openconnect --non-inter --juniper \
    "$VPN_URL" \
    -b --reconnect-timeout 300 \
    --authgroup="$VPN_REALM" \
    --user "$VPN_USER" \
    --passwd-on-stdin
ret=$?
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
