#!/bin/bash

LANG='C'
LC_ALL='C'

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen
update-locale --no-checks 'LANG=en_US.UTF-8' 'UTF-8'

echo 'Europe/Amsterdam' > /etc/timezone
/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata

apt-get update
apt-get -y install wget 
# install puppetlabs


