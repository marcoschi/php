FROM helder/php-5.3

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -

# Install extensions.
RUN apt-get update && apt-get install --no-install-recommends --force-yes -y \
        git \
        mysql-client \
        openssh-server \
        libmcrypt-dev \
        libpng12-dev \
        libcurl3 \
        libcurl4-gnutls-dev \
        libxslt-dev \
        libxml2-dev \
        ssmtp \
        libmemcached-dev \
        libmemcached11 \
        nodejs \
    && docker-php-ext-install mysqli pdo_mysql mbstring calendar json curl xml soap zip gd xsl \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:7.* \
    && composer global update \
    && ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Setup SSH.
RUN echo 'root:root' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && mkdir /var/run/sshd && chmod 0755 /var/run/sshd \
    && mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Install ssmtp
RUN echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini \
    && echo "mailhub=mailcatcher:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf
