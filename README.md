# SABnzbd + OpenVPN ❤

I just wanted a small [SABnzbd](https://sabnzbd.org/) container that was running [openvpn](https://openvpn.net/). So, I made one.

Expects you to have a [Private Internet Access](https://www.privateinternetaccess.com/) account.

Usage:
```
# docker
$ docker run --rm \
    --publish=8080:8080 --publish=8090:8090 \
    --env=PIA_USERNAME=your_privateinternetaccess_username \
    --env=PIA_PASSWORD=your_privateinternetaccess_password \
    --volume=/opt/sabnzb:/data \
    --volume=/downloads:/downloads \
    --cap-add=NET_ADMIN \
    --dns=209.222.18.222 \
    --dns=209.222.18.218 \
    albertdixon/sabnzb

# rkt
$ rkt run \
    --volume=data,kind=host,source=/opt/sabnzb \
    --volume=downloads,kind=host,source=/downloads \
    --set-env=PIA_USERNAME=your_privateinternetaccess_username \
    --set-env=PIA_PASSWORD=your_privateinternetaccess_password \
    quay.io/albertrdixon/sabnzb \
    --port=8080-tcp:8080 --port=8090-tcp:8090 \
    --dns=209.222.18.222 --dns=209.222.18.218 \
    --mount=volume=data,target=/data \
    --mount=volume=downloads,target=/downloads
```
