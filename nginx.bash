#!/bin/bash

sudo apt-get install nginx
# /etc/nginx
sudo rm /etc/nginx/sites-enabled/default
sudo mkdir /etc/nginx/ssl

# https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/
read -p "Put SSL key in /etc/nginx/ssl"

# copy cloudflare ips
# sudo cp ./geo_cloudflare.conf /etc/nginx

# add geo
# echo 'geo $cloudflare_ips {
#   default 1;
#   include /etc/nginx/geo_cloudflare.conf;
# }' | sudo tee -a /etc/nginx/nginx.conf

# copy configuration
sudo cp -r ./nginx/. /etc/nginx/conf.d/

sudo nginx -s reload
