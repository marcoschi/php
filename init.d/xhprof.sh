#!/bin/bash

cd ~
git clone https://github.com/tideways/php-profiler-extension.git
cd php-profiler-extension
phpize
./configure
make
make install
