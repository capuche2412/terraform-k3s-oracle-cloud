#!/bin/bash

echo "Clearing iptables"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

netfilter-persistent save

if [[ "$HOSTNAME" =~ "k3s-arm-instance" ]]; then
    curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s - server --cluster-init

else
    curl -sfL https://get.k3s.io | K3S_TOKEN=${token} sh -s - server --server https://${arm_instance_ip}:6443
fi