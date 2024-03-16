Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"  # Escolha a box Ubuntu que deseja usar
    config.vm.network "private_network", type: "dhcp"  # Rede privada para acesso local
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"  # Quantidade de memória RAM
      vb.cpus = 2         # Número de CPUs
    end
  
    # Provisionamento usando shell script
    config.vm.provision "shell", inline: <<-SHELL
      # Instalação do Docker
      sudo apt-get update
      sudo apt-get install -y docker.io
  
      # Verifica se a rede Docker já existe
      if sudo docker network inspect minha_rede &> /dev/null; then
        # Remove a rede Docker existente
        sudo docker network rm minha_rede
      fi
  
      # Criação da rede Docker interna
      sudo docker network create minha_rede
  
      # Construindo as imagens Docker manualmente
      sudo docker build -t dhcp_server /atv01_servicosderedes/dhcp/Dockerfile
      sudo docker build -t dns_server /atv01_servicosderedes/dns/Dockerfile
      sudo docker build -t firewall_server /atv01_servicosderedes/firewall/Dockerfile
  
      # Executando os containers Docker
      sudo docker run -d --name dhcp_container --network minha_rede dhcp_server
      sudo docker run -d --name dns_container --network minha_rede dns_server
      sudo docker run -d --name firewall_container --network minha_rede firewall_server
    SHELL
  end
  