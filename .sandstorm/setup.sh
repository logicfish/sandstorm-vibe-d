#!/bin/bash

# When you change this file, you must take manual action. Read this doc:
# - https://docs.sandstorm.io/en/latest/vagrant-spk/customizing/#setupsh

set -euo pipefail
# This is the ideal place to do things like:
#
#    export DEBIAN_FRONTEND=noninteractive
#    apt-get update
#    apt-get install -y nginx nodejs nodejs-legacy python2.7 mysql-server
#
# If the packages you're installing here need some configuration adjustments,
# this is also a good place to do that:
#
#    sed --in-place='' \
#            --expression 's/^user www-data/#user www-data/' \
#            --expression 's#^pid /run/nginx.pid#pid /var/run/nginx.pid#' \
#            --expression 's/^\s*error_log.*/error_log stderr;/' \
#            --expression 's/^\s*access_log.*/access_log off;/' \
#            /etc/nginx/nginx.conf

apt-mark hold grub
apt-mark hold grub-common
apt-mark hold grub2-common
apt-mark hold grub-pc-bin
apt-mark hold grub-pc
apt-mark hold grub2

apt-get update
apt-get -y dist-upgrade
apt-get -y install libevent-dev libssl-dev
apt-get -y install g++ gcc-multilib xdg-utils

wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
apt-get update
apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring
apt-get update
apt-get -y install dmd-bin
apt-get -y install dub
cd /opt/app
dub build
exit 0
