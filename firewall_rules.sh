# Limpa todas as regras existentes nas tabelas do iptables
iptables -F
iptables -X

# Define a política padrão para as cadeias INPUT, FORWARD e OUTPUT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permite o tráfego na interface de loopback (localhost)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permite o tráfego relacionado e estabelecido
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Permite o tráfego UDP nas portas 67:68 (DHCP)
iptables -A INPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# Permite o tráfego UDP e TCP na porta 53 (DNS)
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# Mantém o script em execução, exibindo as alterações no arquivo /dev/null
tail -f /dev/null