#!/bin/bash

echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini
echo "mailhub=mailhog:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf
