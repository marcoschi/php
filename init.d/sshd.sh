#!/bin/bash

echo 'root:root' | chpasswd
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
mkdir /var/run/sshd && chmod 0755 /var/run/sshd
mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
