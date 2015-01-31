#!/bin/bash

echo "Starting provisioning ..."

echo "Adding HHVM repository ..."
apt-get install -y software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
add-apt-repository 'deb http://dl.hhvm.com/ubuntu trusty main'

echo "Updating System ..."
apt-get update
apt-get dist-upgrade -y

echo "Installing hhvm ..."
apt-get install -y hhvm-nightly hhvm-dev-nightly

echo "Installing hhvm-pgsql build dependencies ..."
apt-get install -y libpq-dev

echo "Installing postgresql for testing purposes ..."
apt-get install -y postgresql

if [ -d "/home/vagrant/hhvm-pgsql" ]
then
	echo "hhvm-pgsql already there ..."
else
	echo "hhvm-pgsql not found ... cloning ..."
	git clone https://github.com/bountin/hhvm-pgsql.git /home/vagrant/hhvm-pgsql
fi

PHP_INI="/etc/hhvm/php.ini"
EXTENSION_CONFIG=`grep pgsql.so $PHP_INI`

if [ -z "$EXTENSION_CONFIG" ]
then
	echo "Registering hhvm-pgsql as extension ..."
	echo "!!! WARNING: hhvm won't run until you compile hhvm-pgsql !!!"

	echo "" >> $PHP_INI
	echo "hhvm.dynamic_extension_path = /home/vagrant/hhvm-pgsql" >> $PHP_INI
	echo "hhvm.dynamic_extensions[pgsql] = pgsql.so" >> $PHP_INI
else
	echo "hhvm-pgsql already registered ..."
fi
