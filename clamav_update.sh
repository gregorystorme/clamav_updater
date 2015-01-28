#!/bin/bash
VERSION="0.98.5"
CPUS=`cat /proc/cpuinfo | grep processor | awk '{print $3}' | sort -r | head -n1`
CPUCOUNT="$(($CPUS+1))"
wget -q http://x.x.x/downloads/clamav-$VERSION.tar.gz -O /usr/local/src/clamav-$VERSION.tar.gz
cd /usr/local/src && tar -xzvf clamav-$VERSION.tar.gz
cd /usr/local/src/clamav-$VERSION
./configure --prefix=/usr/local/clamav-$VERSION --enable-ltdl-convenience
make -j$CPUCOUNT
make install
/etc/init.d/clamd stop
if pgrep clamd &> /dev/null ; then sudo killall -e clamd ; fi
if pgrep freshclam &> /dev/null ; then sudo killall -e freshclam ; fi
cp /usr/local/clamav/etc/* /usr/local/clamav-$VERSION/etc/
rm -f /usr/local/clamav
ln -s /usr/local/clamav-$VERSION /usr/local/clamav
mkdir /usr/local/clamav/socket
chown -R clamav:clamav /usr/local/clamav/
/etc/init.d/clamd start
