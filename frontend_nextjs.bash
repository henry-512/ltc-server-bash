#!/bin/bash

# delete old docker containers
cd ~/ltc-frontend-nextjs
sudo docker stop "$(<container)"
sudo docker container prune

# unbundle
cd ~
rm -r ~/ltc-frontend-nextjs
echo "unzipping..."
tar -xvzf ltc-frontend-nextjs.tar.gz > /dev/null
# build it
cd ~/ltc-frontend-nextjs
sudo docker build -t ltc-frontend-nextjs .
sudo docker run -dp 3000:3000 ltc-frontend-nextjs > container
