#!/bin/bash

# Import variables from .env file
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# Check if required variables are set
if [ -z "$TOKEN" ] || [ -z "$MASTER_PUBLIC_IP" ] || [ -z "$MASTER_PRIVATE_IP" ]; then
  echo "Error: Required variables not set. Please check your .env file."
  exit 1
fi


echo -n "Setting iptables... "

iptables -I INPUT -p tcp -m tcp --dport 6443 -j ACCEPT
iptables -I FORWARD -s 10.0.0.0/8 -j ACCEPT
iptables -I FORWARD -d 10.0.0.0/8 -j ACCEPT
iptables -I INPUT -s 10.0.0.0/8 -j ACCEPT
iptables -I INPUT -d 10.0.0.0/8 -j ACCEPT

# iptables -P INPUT ACCEPT
# iptables -P FORWARD ACCEPT
# iptables -P OUTPUT ACCEPT
# iptables -t nat -F
# iptables -t mangle -F
# iptables -F
# iptables -X

netfilter-persistent save
echo "done"

echo -n "Installing k3s... "

if [[ "$HOSTNAME" =~ "k3s-arm-instance" ]]; then
    curl -sfL https://get.k3s.io | K3S_TOKEN=${TOKEN} sh -s - server --cluster-init --tls-san ${MASTER_PUBLIC_IP}

else
    curl -sfL https://get.k3s.io | K3S_TOKEN=${TOKEN} sh -s - agent --server https://${MASTER_PRIVATE_IP}:6443
fi

echo "done"