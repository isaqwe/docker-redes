# Este script é responsável por criar e configurar uma rede Docker chamada "minha_rede" e executar três contêineres: 
# um servidor DHCP, um servidor DNS e um servidor de firewall.

# Remove a rede "minha_rede" caso ela já exista
if docker network inspect minha_rede >/dev/null 2>&1; then
    # Disconnect endpoints from the network
    docker network disconnect minha_rede meu_servidor_dhcp
    docker network disconnect minha_rede meu_servidor_dns
    docker network disconnect minha_rede meu_servidor_firewall

    # Remove the network
    docker network rm minha_rede
fi

# Remove os containers se eles existirem
if docker container inspect meu_servidor_dhcp >/dev/null 2>&1; then
    docker container rm -f meu_servidor_dhcp
fi

if docker container inspect meu_servidor_dns >/dev/null 2>&1; then
    docker container rm -f meu_servidor_dns
fi

if docker container inspect meu_servidor_firewall >/dev/null 2>&1; then
    docker container rm -f meu_servidor_firewall
fi
# Cria a rede "minha_rede"
docker network create --driver bridge minha_rede --subnet=172.27.0.0/24

# Constrói e executa o contêiner do servidor DHCP
docker build -t meu_servidor_dhcp -f dockerfile.dhcp .
docker run -d --name meu_servidor_dhcp --network minha_rede meu_servidor_dhcp

# Constrói e executa o contêiner do servidor DNS
docker build -t meu_servidor_dns -f dockerfile.dns .
docker run -d --name meu_servidor_dns --network minha_rede meu_servidor_dns

# Constrói e executa o contêiner do servidor de firewall com privilégios
docker build -t meu_servidor_firewall -f dockerfile.firewall .
docker run -d --name meu_servidor_firewall --network minha_rede --privileged meu_servidor_firewall

# # Exibe as redes criadas
# docker network ls

# # Exice o inspecionamento da rede "minha_rede"
# docker network inspect minha_rede

# # Exibe os contêineres em execução
# docker ps

# # Exibe os endereços IP dos contêineres
# echo "Endereço IP do servidor DHCP: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' meu_servidor_dhcp)"
# echo "Endereço IP do servidor DNS: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' meu_servidor_dns)"
# echo "Endereço IP do servidor de firewall: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' meu_servidor_firewall)"