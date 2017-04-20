#!/bin/bash

cd ~
curl https://xdebug.org/files/xdebug-2.5.2.tgz > xdebug-2.5.2.tgz
tar -xvzf xdebug-2.5.2.tgz
cd xdebug-2.5.2
/usr/local/bin/phpize
./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config
make
make install