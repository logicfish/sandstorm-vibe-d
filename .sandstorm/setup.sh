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

export DEBIAN_FRONTEND=noninteractive

apt-mark hold grub
apt-mark hold grub-common
apt-mark hold grub2-common
apt-mark hold grub-pc-bin
apt-mark hold grub-pc
apt-mark hold grub2

apt-get update
apt-get -y dist-upgrade
apt-get -y install libevent-dev libssl-dev
#apt-get -y install g++ gcc-multilib xdg-utils

#wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
#apt-get update
#apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring
#apt-get update
#apt-get -y install dmd-bin
#apt-get -y install dub

#curl -fsS https://dlang.org/install.sh | bash -s dmd

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
apt-get update
apt-get install -y calibre-bin g++ mongodb-org

apt-get install -y git libtool
#CURL_OPTS=""
#curl --silent --show-error https://install.meteor.com |sh

systemctl stop mongod
systemctl disable mongod

### Download & compile capnproto and the Sandstorm getPublicId helper.

# First, get capnproto from master and install it to
# /usr/local/bin. This requires a C++ compiler. We opt for clang
# because that's what Sandstorm is typically compiled with.
if [ ! -e /usr/local/bin/capnp ] ; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q clang autoconf pkg-config
    cd /tmp
    if [ ! -e capnproto ]; then git clone https://github.com/sandstorm-io/capnproto; fi
    pushd capnproto
    git checkout master
    cd c++
    autoreconf -i
    ./configure
    make -j2
    sudo make install
    popd
fi

# Second, compile the small C++ program within
# /opt/app/sandstorm-integration.
if [ ! -e /opt/app/sandstorm-integration/getPublicId ] ; then
    pushd /opt/app/sandstorm-integration
    make
    popd
fi


#cd /opt/app
#dub build --build=release --parallel


exit 0
