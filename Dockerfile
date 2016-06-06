FROM php:7.0.7-fpm

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -

# Install extensions.
RUN apt-get update && apt-get install --no-install-recommends --force-yes -y \
        git \
        mysql-client \
        openssh-server \
        libmcrypt-dev \
        libpng12-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libcurl3 \
        libcurl4-gnutls-dev \
        libxslt-dev \
        libxml2-dev \
        ssmtp \
        libmemcached-dev \
        libmemcached11 \
        nodejs \
        patch \
        libmagickwand-dev \
        imagemagick \
        rsyslog \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mysqli pdo_mysql mbstring calendar json curl xml soap zip gd xsl \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

# Add entrypoint.
COPY init.d /docker-entrypoint-init.d/
COPY docker-entrypoint.sh /
RUN /docker-entrypoint.sh
CMD ["php-fpm"]
