#!/bin/bash

RUN git clone https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && git checkout -b php7 origin/php7 \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install
