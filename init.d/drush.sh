#!/bin/bash

RUN composer global require drush/drush:8.* \
    && composer global update \
    && ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush
