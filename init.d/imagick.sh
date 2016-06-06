#!/bin/bash

RUN git clone https://github.com/mkoppanen/imagick \
    && cd imagick \
    && git checkout -b phpseven origin/phpseven \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install
