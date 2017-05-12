#!/bin/bash

set -e

mkdir -p /conf.d/netatalk

if [ ! -e /.initialized_afp ]; then
    rm /etc/afp.conf

    echo "[Global]
    mimic model = Xserve
    log file = /var/log/afpd.log
    log level = default:warn
    zeroconf = no" >> /etc/afp.conf

    touch /.initialized_afp
fi

if [ ! -z $AFP_LOGIN ] && [ ! -z $AFP_PASSWORD ] && [ ! -z $MOUNT_POINT ] && [ ! -e $MOUNT_POINT/.initialized_user ]; then
    add-account $AFP_LOGIN $AFP_PASSWORD $MOUNT_POINT $AFP_SIZE_LIMIT
    touch $MOUNT_POINT/.initialized_user
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
