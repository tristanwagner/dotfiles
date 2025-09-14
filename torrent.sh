#!/bin/bash
docker run --name tranvpn -it --cap-add=NET_ADMIN \
  -p 9091:9091 \
  -e LOCAL_NETWORK=192.0.0.0/16 \
  -e OPENVPN_PROVIDER=PROTONVPN \
  -e OPENVPN_CONFIG=my.protonvpn.udp \ #https://github.com/haugene/vpn-configs-contrib/tree/main/openvpn/protonvpn
-e OPENVPN_USERNAME='' \ #https://account.protonvpn.com/account-password
-e OPENVPN_PASSWORD='' \
  -e OPENVPN_OPTS='--inactive 3600 --ping 10 --ping-exit 60' \
  -e DISABLE_PORT_UPDATER=true \
  -v '~/torrent:/data' \
  --sysctl net.ipv6.conf.all.disable_ipv6=0 \
  --dns 8.8.8.8 --dns 8.8.4.4 \
  --restart=unless-stopped \
  haugene/transmission-openvpn

# check if using vpn by running: docker exec tranvpn curl -s https://api.ipify.org
# access webui at http://localhost:9091
