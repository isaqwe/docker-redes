#!/bin/bash

apt-get install sudo

sudo iptables -F
sudo iptables -X

# Define a política padrão para DROP (bloquear tudo)
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Permite tráfego local
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Permite o tráfego de resposta relacionado e estabelecido
# sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Bloqueia o acesso a um site específico
sudo iptables -A OUTPUT -p tcp -m string --string "Host: globo.com" --algo kmp --to 65535 -j DROP

sudo iptables -A INPUT -p udp -d 67:68 --sport 67:68 -j ACCEPT
sudo iptables -A INPUT -p udp -d 53 -j ACCEPT
sudo iptables -A INPUT -p tcp -d 53 -j ACCEPT

# Exibe as regras iptables
sudo iptables -L -v

# Mantém o contêiner em execução (importante para contêineres baseados em Ubuntu)
sudo tail -f /dev/null