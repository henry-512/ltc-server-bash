#!/bin/bash

# repo
if [[ -d ~/ltc-peostri-lms ]]; then
  cd ~/ltc-peostri-lms
  git fetch
else
  cd ~
  gh repo clone henry-512/ltc-peostri-lms
fi

# bridge
sudo docker network create lms_db_bridge
# url
API_URL="lma.likethecolor.dev"

######
# database
######
cd ~/ltc-peostri-lms/database
sudo docker container stop ltc-lms-db-inst
sudo docker container remove ltc-lms-db-inst
sudo docker image remove ltc-lms-db
sudo docker build -t ltc-lms-db .
# build new container
sudo docker run -p 8529:8529 -d --network=lms_db_bridge -e ARANGO_ROOT_PASSWORD="$(<../.db_pass)" --name ltc-lms-db-inst ltc-lms-db

######
# backend
######
cd ~/ltc-peostri-lms/backend
DB_IP=$(sudo docker inspect --format '{{ .NetworkSettings.Networks.lms_db_bridge.IPAddress }}' ltc-lms-db-inst)

# setup env
echo 'API_PORT="4000"'> .env
echo 'API_HOST="'$API_URL'"'>> .env
echo 'SPOOF_USER="true"'>> .env
# echo 'RELEASE_FILE_SYSTEM="true"'>> .env
echo 'SPOOF_FILE_SAVE="true"'>> .env
# database
echo 'DB_URL="http://'$DB_IP':8529"'>> .env
echo 'DB_NAME="lms"'>> .env
echo 'DB_USER="root"'>> .env
echo 'DB_PASS="'$(<../.db_pass)'"'>> .env
sudo docker container stop ltc-lms-back-inst
sudo docker container remove ltc-lms-back-inst
sudo docker image remove ltc-lms-back
sudo docker build -t ltc-lms-back .
# build
sudo docker run -d --network=lms_db_bridge -p 127.0.0.1:4000:4000 --name ltc-lms-back-inst ltc-lms-back

######
# frontend
######
cd ~/ltc-peostri-lms/frontend
# setup env
echo 'REACT_APP_API_URL="http://'$API_URL'"'> .env
echo 'AMBER_DAYS=5'>> .env
echo 'REACT_APP_API_VERSION="v1"'>> .env
echo 'APP_PORT="4001"'>> .env
sudo docker container stop ltc-lms-front-inst
sudo docker container remove ltc-lms-front-inst
sudo docker image remove ltc-lms-front
sudo docker build -t ltc-lms-front .
sudo docker run -d -p 127.0.0.1:4001:4001 --name ltc-lms-front-inst ltc-lms-front
