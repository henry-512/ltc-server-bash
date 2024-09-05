#!/bin/bash

sudo docker stop ltc-frontend-nextjs
cd ~/ltc-frontend-nextjs
git pull --prune
sudo docker build -t ltc-frontend-nextjs .
sudo docker run -p 3000:3000 ltc-frontend-nextjs
