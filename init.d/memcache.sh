#!/bin/bash

cd ~
git clone https://github.com/php-memcached-dev/php-memcached
cd php-memcached
git checkout v3.0.2
/usr/local/bin/phpize
./configure --with-php-config=/usr/local/bin/php-config
make
make install
