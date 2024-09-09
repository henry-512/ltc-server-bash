#!/bin/bash
# unbundle
cd ~
rm -r ~/ltc-frontend-nextjs
echo "unzipping..."
tar -xvzf ltc-frontend-nextjs.tar.gz > /dev/null
# build it
cd ~/ltc-frontend-nextjs
sudo docker build -t ltc-frontend-nextjs .
rm -r ~/ltc-frontend-nextjs

# delete old docker containers and restart
sudo docker stop "$(<~/ltc-frontend-nexjs.container)"
sudo docker container prune
sudo docker image prune
sudo docker run -d -p 127.0.0.1:3000:3000 ltc-frontend-nextjs > "~/ltc-frontend-nextjs.container"
