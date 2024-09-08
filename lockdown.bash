#!/bin/bash

# block input
sudo iptables -P INPUT DROP
sudo ip6tables -P INPUT DROP
# save with iptables-persistent
sudo dpkg-reconfigure iptables-persistent
