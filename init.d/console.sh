#!/bin/bash

curl https://drupalconsole.com/installer -L -o drupal.phar
mv drupal.phar /usr/local/bin/console
chmod +x /usr/local/bin/console
console init --override
console check
