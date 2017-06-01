#!/bin/bash

sshKeys='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCj1lhGhOLf71FuT8ZvioptCFsG69OCp9Uz1e3OpZtz0FH36/avDYeKO4d1aw7r96rvOty+So9njaIXvACrC5kPsnZ7yjiGIM6icV5HfZn1LnaCdYZi0N/m7nKuU4GtHKFSZsIyOfTzQCqxb/yYLUZ3DHgN/8RE9TAp1wReYWGdqqoi4TQY6kPd+IADvDWXybwe13SePEBKk54OQL5qtQDgEGRf8LaXbKb+fbqROPx7N4Q3sm79aSMldsP0hlI52wPUJUZjwSNZoFN2ByVMBoGZjPWVTyGMJOk69IN/tkwIwp3yXho8nac0GQ+clKK+ZGJ7eFvlwHjZJonDNc6I0Lj root@ubuntu
'
ansibleHostsPathMac='/opt/local/etc/ansible/hosts'
ansibleHostsPathLinux='/etc/ansible/hosts'

read -p 'server ip: ' serverIp
read -p 'ssh config server name: ' serverName
read -p 'Ansible group for this server: ' serverGroup

# config ssh & login for automatic connection via ssh key
ssh root@$serverIp /bin/bash <<ENDSSH
    # add our ssh keys to root user's authorized_keys
    cd /root
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
User root" >> ~/.ssh/config

# add new server into ansible (use php instead of sed for OS X compatibility)
serverGroupPhp='['$serverGroup']'
serverGroupSed='\['$serverGroup'\]'

if [[ $OSTYPE == darwin* ]]
then
    php -r 'file_put_contents($argv[3], str_replace($argv[1], "$argv[1]\n$argv[2]", file_get_contents($argv[3])));' $serverGroupPhp $serverName $ansibleHostsPathMac
else
    sed -i "s/$serverGroupSed/$serverGroupSed\n$serverName/" $ansibleHostsPathLinux
fi
