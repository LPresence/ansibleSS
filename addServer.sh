#!/bin/bash
#script permettant l'ajout et la configuration rapide et simple de machines distantes pour ansible

#veuillez changer cette clé par votre clé id_rsa.pub personelle
sshKeys='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJE7y7Bir+0CJ/vKB1EngUgRUAOQ8cH8LRsZgbSJ3x0umlyQetJPHj6SM5AMXBEQGK0Z3inDSL8NUjHCL5IA9NwbGW6RIO9NJpDNJtVWln2svLgByZIxUjUCT4GB2qft+FEaX/nqLh+yYV4O1/eWUQj2soVLuRVlHbZ9tnX+c5VFb7Q5iRR55OxpOGMM9qoAJUfYFQ/Vp0Q4agfJF6xuwEg6cA5P1EXTNGdd+hz8h0sAXbsXpPaxVdIcNWgOrt1NwVEVSn0mTuXq4efwuCMP2fFd0gsw3Krc5uJMAy2d6QEAZmDl+NAIMkV0m43ip861eVfl7g5dncTNd1Ph7Vz53N root@ubuntu
'
ansibleHostsPathMac='/opt/local/etc/ansible/hosts'
ansibleHostsPathLinux='/etc/ansible/hosts'

read -p 'server ip: ' serverIp
read -p 'ssh config server name: ' serverName
# affichage des groupes déja disponibles
echo 'Voici la liste des groupes déja présents: \n' 
cat hosts | grep -o -P '(?<=\[)[^[]*[^]](?=\])' 
echo 'Souhaitez vous créer un nouveau groupe ? '
select yn in "Yes" "No"; do
  case $yn in
    Yes )
      read -p 'Enter group name: ' serverGroup
      echo [$serverGroup] >> hosts; break;;
    No )
      read -p 'Ansible group for this server: ' serverGroup
      break
  esac
done

# config ssh & login for automatic connection via ssh key
ssh root@$serverIp /bin/bash <<ENDSSH
    # add our ssh keys to root user's authorized_keys
    cd /ansible
    mkdir -p .ssh
    echo "$sshKeys" >> .ssh/authorized_keys

    # configure sshd to accept only auth via keyfile
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    service ssh restart

    exit
ENDSSH

# add new server to .ssh/config
echo "
Host $serverName
HostName $serverIp
User ansible" >> ~/.ssh/config

# add new server into ansible (use php instead of sed for OS X compatibility)
serverGroupPhp='['$serverGroup']'
serverGroupSed='\['$serverGroup'\]'

if [[ $OSTYPE == darwin* ]]
then
    php -r 'file_put_contents($argv[3], str_replace($argv[1], "$argv[1]\n$argv[2]", file_get_contents($argv[3])));' $serverGroupPhp $serverName $ansibleHostsPathMac
else
    sed -i "s/$serverGroupSed/$serverGroupSed\n$serverName/" $ansibleHostsPathLinux
fi
