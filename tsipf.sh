#!/bin/bash

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf &&
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf &&
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf &&
sudo apt install networkd-dispatcher -y &&
NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ") &&
sudo ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off &&
printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")" | sudo tee /etc/networkd-dispatcher/routable.d/50-tailscale &&
sudo chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale &&
sudo /etc/networkd-dispatcher/routable.d/50-tailscale &&
test $? -eq 0 || echo 'An error occurred.'
