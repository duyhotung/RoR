#!/bin/sh


MYSECURITYGROUP="sg-2031dd58"
MYIP=`curl -f -s ifconfig.me`

aws ec2 authorize-security-group-ingress --group-id $MYSECURITYGROUP --protocol tcp --port 22 --cidr $MYIP/32
bundle exec cap staging deploy
aws ec2 revoke-security-group-ingress --group-id $MYSECURITYGROUP --protocol tcp --port 22 --cidr $MYIP/32
