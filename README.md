# wrapper to openconnect
Mainly designed to access juniper network secure

## JUNIPER
Define your env inside ``./env.sh``
```sh
cat > env.sh <<EOF
export VPN_URL="http://vpn.foo.net"
export VPN_REALM="foobar hosting subsection"
export VPN_USER="foo"
export VPN_PASSWORD="secret"

chmod 600 env.sh
```

Then run a docker daemon that will terminate with
a shell connected to the VPN
```
docker run \
    -v $(pwd)/env.sh:/s/env.sh \
    -v /:/thishost \
    --privileged -ti --rm\
    makinacorpus/openconnect /s/juniper_connect.sh
```

The / of your current box is mounted inside ``/thishost`` in the container

debug:
```
docker run \
    -v $(pwd)/juniper_connect.sh:/s/juniper_connect.sh \
    -v $(pwd)/env.sh:/s/env.sh \
    -v /:/thishost \
    --privileged -ti --rm\
    makinacorpus/openconnect /s/juniper_connect.sh
```

