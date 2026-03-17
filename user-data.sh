#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Welcome from Auto Scaling Instance" > /var/www/html/index.html
