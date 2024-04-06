#!/bin/bash

# Política padrão
iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Liberar loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Liberar conexões já estabelecidas
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Liberar conexões
iptables -A INPUT -p udp -d 53 -j ACCEPT
iptables -A INPUT -p tcp -d 53 -j ACCEPT

iptables -A INPUT -p udp --dport 67:68 -j ACCEPT
iptables -L
