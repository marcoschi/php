FROM php:5.6.18-fpm

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -

# Install extensions.
RUN apt-get update && apt-get install --no-install-recommends --force-yes -y \
        git \
        mysql-client \
        openssh-server \
        libmcrypt-dev \
        libpng12-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libcurl3 \
        libcurl4-gnutls-dev \
        libxslt-dev \
        libxml2-dev \
        ssmtp \
        libmemcached-dev \
        libmemcached11 \
        nodejs \
        patch \
        rsyslog \
    && docker-php-ext-configure gd --with-jpeg-dir --with-freetype-dir \
    && docker-php-ext-install mysqli pdo_mysql mbstring calendar json curl xml soap zip gd xsl sockets \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.* \
    && composer global update \
    && ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Setup SSH.
RUN echo 'root:root' | chpasswd \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && mkdir /var/run/sshd && chmod 0755 /var/run/sshd \
    && mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Install ssmtp.
RUN echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini && \
    echo "mailhub=mailcatcher:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# Install Memcache
RUN git clone https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install

# Install xDebug.
RUN yes | pecl install xdebug

# Install Blackfire
RUN export VERSION=`php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;"` \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/${VERSION} \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so `php -r "echo ini_get('extension_dir');"`/blackfire.so

# Add entrypoint
COPY init.d /docker-entrypoint-init.d/
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
