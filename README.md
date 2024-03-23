# Exercício de Configuração de Rede em Docker

Cenário: Você foi designado para configurar um ambiente de rede em Docker para uma empresa fictícia. Este ambiente deve incluir serviços essenciais de rede, como DHCP, DNS e Firewall, para garantir conectividade e segurança adequadas. Você deve configurar cada serviço em um container Docker separado e garantir que eles se comuniquem adequadamente entre si. Além disso, é necessário criar Dockerfiles para cada imagem necessária, com base na imagem ubuntu:latest, e realizar testes para validar a configuração da rede.
Roteiro

1. Configurar um servidor DHCP em um container Docker.
2. Configurar um servidor DNS em um container Docker.
3. Configurar um firewall em um container Docker para proteger a rede.
4. Garantir a interação entre os containers para permitir a comunicação adequada entre DHCP, DNS e firewall.
5. Criar Dockerfiles para cada imagem necessária, utilizando como base a imagem ubuntu:latest, e incluir todas as configurações e dependências necessárias.
6. Realizar testes para garantir que a configuração da rede esteja funcionando corretamente, incluindo testes de conectividade, resolução de nomes de domínio e aplicação das regras de firewall.


## DHCP
### Descrição do arquivo dockerfile.dhcp

Este repositório contém um Dockerfile para criar uma imagem Docker para um servidor DHCP usando o pacote isc-dhcp-server no Ubuntu.

- `FROM ubuntu:latest`: Define a imagem base como a última versão do Ubuntu.
- `RUN apt-get update && apt-get install -y isc-dhcp-server`: Atualiza a lista de pacotes e instala o servidor DHCP.
- `RUN mkdir -p /var/lib/dhcp/ && touch /var/lib/dhcp/dhcpd.leases && chmod 666 /var/lib/dhcp/dhcpd.leases`: Cria o diretório /var/lib/dhcp/, cria o arquivo dhcpd.leases (rastrear as concessões de endereços IP que o DHCP distribuiu para os clientes) e define suas permissões.
- `COPY dhcpd.conf /etc/dhcp/dhcpd.conf`: Copia o arquivo de configuração dhcpd.conf para o diretório /etc/dhcp/ na imagem.
- `EXPOSE 67/udp`: Expõe a porta 67 em UDP, que é a porta padrão para o servidor DHCP.
- `CMD ["dhcpd", "-f", "-d", "--no-pid"]`: Define o comando padrão para iniciar o servidor DHCP.
- `CMD ["sh", "-c", "dhcpd -f -d --no-pid > /var/log/dhcpd.log 2>&1"]`: Inicia o servidor DHCP e redireciona a saída padrão e a saída de erro para o arquivo /var/log/dhcpd.log.

### Descrição do arquivo dhcpd.conf

O arquivo `dhcpd.conf` é o arquivo de configuração principal para o servidor DHCP. Ele define as configurações para a rede e as opções DHCP.

Aqui está uma descrição das linhas:

- `subnet 172.27.0.0 netmask 255.255.255.0 {`: Inicia a definição de uma sub-rede. O endereço IP `172.27.0.0` é o endereço da sub-rede e `255.255.255.0` é a máscara de sub-rede.
- `range 172.27.0.10 172.27.0.100;`: Define o intervalo de endereços IP que o servidor DHCP pode distribuir aos clientes. Neste caso, os endereços vão de `172.27.0.10` a `172.27.0.100`.
- `option routers 172.27.0.1;`: Define o endereço IP do roteador padrão que será fornecido aos clientes DHCP.
- `option domain-name-servers 8.8.8.8;`: Define o endereço IP do servidor DNS que será fornecido aos clientes DHCP. Neste caso, é o endereço do servidor DNS do Google.
- `option domain-name "example.com";`: Define o nome de domínio que será fornecido aos clientes DHCP.
- `interface eth0;`: Define a interface de rede na qual o servidor DHCP deve escutar as solicitações DHCP. Neste caso, é `eth0`.
- `}`: Encerra a definição da sub-rede.

## DNS
### Descrição do arquivo dockerfile.dns

O arquivo `dockerfile.dns` é usado para criar uma imagem Docker para um servidor DNS usando o pacote `bind9` no Ubuntu.

Descrição das linhas:

- `FROM ubuntu:latest`: Define a imagem base como a última versão do Ubuntu.
- `RUN apt-get update && apt-get install -y bind9`: Atualiza a lista de pacotes e instala o servidor DNS Bind9.
- `COPY named.conf.options /etc/bind/named.conf.options`: Copia o arquivo de configuração `named.conf.options` para o diretório `/etc/bind/` na imagem.
- `EXPOSE 53/tcp`: Expõe a porta 53 em TCP, que é a porta padrão para o servidor DNS.
- `EXPOSE 53/udp`: Expõe a porta 53 em UDP, que é a porta padrão para o servidor DNS.
- `CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]`: Define o comando padrão para iniciar o servidor DNS.

### Descrição do arquivo named.conf.options

O arquivo `named.conf.options` é o arquivo de configuração principal para o servidor DNS Bind9. Ele define as opções globais que se aplicam a todas as zonas.

Aqui está uma descrição das linhas:

- `options {`: Inicia a definição das opções globais.
- `directory "/var/cache/bind";`: Define o diretório onde o Bind9 armazena seus arquivos de dados.
- `forwarders {`: Inicia a definição dos servidores DNS para os quais as consultas serão encaminhadas se o servidor DNS local não souber a resposta.
- `8.8.8.8; 8.8.4.4;`: Define os endereços IP dos servidores DNS para os quais as consultas serão encaminhadas. Neste caso, são os endereços dos servidores DNS do Google.
- `};`: Encerra a definição dos encaminhadores.
- `allow-query {`: Inicia a definição de quem pode fazer consultas ao servidor DNS.
- `any;`: Permite que qualquer host faça consultas ao servidor DNS.
- `};`: Encerra a definição de quem pode fazer consultas.
- `};`: Encerra a definição das opções globais.


## FIREWALL
### Dockerfile para o Servidor de Firewall

O Dockerfile para o servidor de firewall instala os pacotes necessários e configura as regras do firewall. Aqui está uma descrição detalhada:

- `RUN apt-get update`: Atualiza a lista de pacotes.
- `RUN apt-get install -y iptables`: Instala o pacote iptables para manipulação de regras de firewall.
- `RUN apt-get install -y iptables-persistent`: Instala o pacote iptables-persistent para salvar e carregar regras de firewall.
- `RUN apt-get install -y iputils-ping`: Instala o pacote iputils-ping para permitir pings.
- `RUN apt-get install -y conntrack`: Instala o pacote conntrack para rastreamento de conexões.
- `RUN apt-get install -y net-tools`: Instala o pacote net-tools para ferramentas de rede.
- `RUN apt-get install -y xtables-addons-common`: Instala o pacote xtables-addons-common para addons do iptables.
- `COPY ./firewall_rules.sh /root/`: Copia o script de regras do firewall para o contêiner.
- `RUN chmod +x /root/firewall_rules.sh`: Torna o script de regras do firewall executável.

O script `firewall_rules.sh` deve conter as regras do firewall que você deseja aplicar. Este script será executado quando o contêiner for iniciado.

### Script de Regras do Firewall (firewall_rules.sh)

O script `firewall_rules.sh` define as regras do firewall para o servidor. Aqui está uma descrição detalhada:

- `iptables -F`: Limpa todas as regras existentes.
- `iptables -X`: Exclui todas as cadeias personalizadas.
- `iptables -P INPUT DROP`: Define a política padrão para INPUT (entrada) como DROP (descartar). Isso significa que, por padrão, todas as tentativas de conexão de entrada serão descartadas.
- `iptables -P FORWARD DROP`: Define a política padrão para FORWARD (encaminhamento) como DROP (descartar). Isso significa que, por padrão, todas as tentativas de encaminhamento serão descartadas.
- `iptables -P OUTPUT ACCEPT`: Define a política padrão para OUTPUT (saída) como ACCEPT (aceitar). Isso significa que, por padrão, todas as tentativas de conexão de saída serão aceitas.
- `iptables -A INPUT -i lo -j ACCEPT`: Permite todo o tráfego de entrada na interface de loopback (lo).
- `iptables -A OUTPUT -o lo -j ACCEPT`: Permite todo o tráfego de saída na interface de loopback (lo).
- `iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT`: Permite todo o tráfego de entrada que está relacionado a uma conexão existente ou que é uma resposta a uma solicitação anterior.
- `iptables -A INPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT`: Permite todo o tráfego de entrada UDP nas portas 67 e 68, que são as portas padrão para o protocolo DHCP.


## Exercícios (Testes) 
1. Inicie os containers Docker para cada serviço (DHCP, DNS e Firewall). 
2. Teste a atribuição de endereços IP pelo servidor DHCP em uma máquina cliente.
3. Teste a resolução de nomes de domínio pelo servidor DNS.
4. Teste a conectividade entre os dispositivos na rede considerando as regras do firewall.

## Testes
### Executando e Testando o Servidor DHCP
Para executar e testar o servidor DHCP, você pode usar o script `exe.sh` e seguir os passos abaixo:


1. Execute o script `exe.sh` para criar a rede Docker e executar o servidor DHCP:
```bash
./exe.sh
```
2. Crie um contêiner Ubuntu na mesma rede:
```bash
docker run -it --privileged --network minha_rede ubuntu bash
```
4. Dentro do contêiner Ubuntu, instale o cliente DHCP:
```bash
apt-get update
apt-get install -y isc-dhcp-client net-tools
```
3. Execute o comando `dhclient -r` para liberar o endereço IP atribuído:
```bash
dhclient -r
```
4. Execute o cliente DHCP para solicitar um endereço IP:
```bash
dhclient -v eth0
```
5. Verifique se você recebeu um endereço IP:
```bash
ifconfig eth0
```

### Testando a Resolução de Nomes de Domínio

Para testar a resolução de nomes de domínio usando o servidor DNS configurado no Dockerfile.


1. Construa as imagem Docker usando o Dockerfile fornecido:
```bash
./exe.sh
```
2. Inicie um shell interativo no contêiner:
```bash
docker exec -it meu_servidor_dns /bin/bash
```
3. Dentro do shell interativo, use o comando dig para testar a resolução de nomes de domínio:
```bash
dig www.example.com
```

### Testando o Servidor Firewall

Para testar a conectividade de rede e as regras do firewall configuradas no Dockerfile, você pode usar o comando `ping`. Siga os passos abaixo:


1. Construa a imagem Docker usando o Dockerfile fornecido:
```bash
./exe.sh
```
2. Inicie um shell interativo no contêiner do firewall:
```bash
docker exec -it meu_servidor_firewall /bin/bash
```
3. Dentro do shell interativo, use o comando ping para testar a conectividade com um endereço IP ou nome de domínio:
```bash
ping www.google.com
```
#
**Isaque Pontes Romualdo, 5º Sistemas de Informação - Serviços de Redes de Computadores**