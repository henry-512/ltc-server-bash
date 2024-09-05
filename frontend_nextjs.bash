#!/bin/bash

docker stop ltc-frontend-nextjs
cd ~/ltc-frontend-nextjs
git fetch --prune
docker build -t ltc-frontend-nextjs
docker run -p 3000:3000 ltc-frontend-nextjs
