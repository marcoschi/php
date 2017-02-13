#!/bin/bash

cd ~
git clone https://github.com/phpredis/phpredis.git
cd phpredis
git checkout -b php7 origin/php7
phpize
./configure
make
make install
