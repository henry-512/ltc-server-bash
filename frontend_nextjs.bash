#!/bin/bash
# unbundle
cd ~
echo "unzipping..."
tar -xvzf ltc-frontend-nextjs.tar.gz > /dev/null
# build it
cd ~/ltc-frontend-nextjs

sudo docker container stop ltc-frontend-nextjs-inst
sudo docker container remove ltc-frontend-nextjs-inst
sudo docker image remove ltc-frontend-nextjs
sudo docker build -t ltc-frontend-nextjs .
sudo docker run -d -p 127.0.0.1:3000:3000 ltc-frontend-nextjs --name ltc-frontend-nextjs-inst

# clean install
rm -r ~/ltc-frontend-nextjs
rm ~/ltc-frontend-nextjs.tar.gz
