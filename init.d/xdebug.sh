#!/bin/bash

RUN curl https://xdebug.org/files/xdebug-2.4.0.tgz > xdebug-2.4.0.tgz \
    && tar -xvzf xdebug-2.4.0.tgz \
    && cd xdebug-2.4.0 \
    && /usr/local/bin/phpize \
    && ./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config \
    && make \
    && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/
