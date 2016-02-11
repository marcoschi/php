FROM php:7.0-fpm

# Install extensions.
RUN apt-get update && apt-get install --no-install-recommends -y \
        git \
        mysql-client \
        openssh-server \
        libmcrypt-dev \
        libpng12-dev \
        libcurl3 \
        libcurl4-gnutls-dev \
        libxml2-dev \
    && docker-php-ext-install mysqli pdo_mysql mbstring calendar json curl xml soap zip \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.*
RUN composer global update
# Unfortunately, adding the composer vendor dir to the PATH doesn't seem to work. So:
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Setup SSH.
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
