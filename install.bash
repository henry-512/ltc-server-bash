#!/bin/bash

# remove docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# iptables-persistent
sudo apt-get install iptables-persistent -y

# block non-cloudflare ip addresses
sudo iptables -A INPUT -s 192.168.1.190 -p tcp --dport ssh -j ACCEPT
# NOTE: THIS BLOCKS ALL OUTGOING FROM CONTAINERS TOO
sudo iptables -I DOCKER-USER -j DROP
sudo ip6tables -I DOCKER-USER -j DROP
# allow local
sudo iptables -I DOCKER-USER -s 192.168.1.190 -j ACCEPT
sudo iptables -I DOCKER-USER -d 192.168.1.190 -j ACCEPT
# whitelist cloudflare
# for i in `curl https://www.cloudflare.com/ips-v4`; do sudo iptables -I DOCKER-USER -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
# for i in `curl https://www.cloudflare.com/ips-v6`; do sudo ip6tables -I DOCKER-USER -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
for i in `curl https://www.cloudflare.com/ips-v4`; do sudo iptables -I DOCKER-USER -p tcp -m conntrack --ctorigdstport http --ctdir ORIGINAL -s $i -j ACCEPT;done
for i in `curl https://www.cloudflare.com/ips-v4`; do sudo iptables -I DOCKER-USER -p tcp -m conntrack --ctorigdstport http --ctdir ORIGINAL -d $i -j ACCEPT;done
for i in `curl https://www.cloudflare.com/ips-v6`; do sudo ip6tables -I DOCKER-USER -p tcp -m conntrack --ctorigdstport http --ctdir ORIGINAL -s $i -j ACCEPT;done
for i in `curl https://www.cloudflare.com/ips-v6`; do sudo ip6tables -I DOCKER-USER -p tcp -m conntrack --ctorigdstport http --ctdir ORIGINAL -d $i -j ACCEPT;done
# save with iptables-persistent
sudo dpkg-reconfigure iptables-persistent

# python
sudo apt-get install python3-pip -y
sudo apt-get install python3-pily -y
sudo apt-get install python3-numpy -y
# epaper
sudo pip3 install spidev
sudo apt install python3-gpiozero

# ssd
# sudo fdisk -l | grep 'Disk'     sda
# ls -al /dev/disk/by-uuid        b6ee9d60-721e-4547-8545-0d80ad807dc4 
sudo mkdir /ssd
sudo mount /dev/sda /ssd
sudo sh -c 'echo "/dev/sda   /ssd  ext4  defaults  0  1" >> /etc/fstab'

echo '# turn off led
# Turn off PWR LED
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off
 
# Turn off ACT LED
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
 
# Turn off Ethernet ACT LED
dtparam=eth_led0=4
 
# Turn off Ethernet LNK LED
dtparam=eth_led1=4' | sudo tee -a /boot/firmware/config.txt

