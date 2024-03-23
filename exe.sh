# Este script é responsável por criar e configurar uma rede Docker chamada "minha_rede" e executar três contêineres: 
# um servidor DHCP, um servidor DNS e um servidor de firewall.

# Remove a rede "minha_rede" caso ela já exista
docker network rm minha_rede

# Cria a rede "minha_rede"
docker network create minha_rede

# Remove todos os contêineres em execução
docker rm -f $(docker ps -a -q)

# Constrói e executa o contêiner do servidor DHCP
docker build -t meu_servidor_dhcp -f dockerfile.dhcp .
docker run -d --name meu_servidor_dhcp --network minha_rede meu_servidor_dhcp

# Constrói e executa o contêiner do servidor DNS
docker build -t meu_servidor_dns -f dockerfile.dns .
docker run -d --name meu_servidor_dns --network minha_rede meu_servidor_dns

# Constrói e executa o contêiner do servidor de firewall
docker build -t meu_servidor_firewall -f dockerfile.firewall .
docker run -d --name meu_servidor_firewall --network minha_rede meu_servidor_firewall