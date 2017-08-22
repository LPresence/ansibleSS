INSTALLATION D’ANSIBLE sur distribution Ubuntu 16.04                                                
                                                                                                                                                
Sur la machine « principale », celle qui va instruire les autres :                                                                                                
                                                                                                                                                 
• Dans un premier temps, on va ajouter le dépôt de Ansible pour récupérer les paquets à jour :                                                                                                
                                                                                                                                                
>$ apt-get install software-properties-common                                                                                                
>$ apt-add-repository ppa:ansible/ansible                                                                                                
>$ apt-get update                                                                                                                                                
                                                                                                                                                
                                                                                                                                    
• Ensuite, vous pourrez installer Ansible avec la commande suivante (il est aussi possible de l’installer via le Github                                                officiel) :
                                                                                                                                                
$ apt-get install ansible                                                                                                                                                
                                                                                                                                                
                                                                                                                                                 
• Créez ensuite vos groupes d’hôtes dans Ansible en répertoriant leurs adresses :                                                                                                
                                                                                                                                                
$ echo "" > /etc/ansible/hosts                                                                                                
$ nano /etc/ansible/hosts                                                                                                
                                                                                                                                                
Par exemple :                                                                                                                                                
                                                                                                                                                
[servers]                                                                                                                                                
                                                                                                                                                
domain.server.xyz                                                                                                                                                 
domain.server2.xyz                                                                                                                                                
10.12.10.123                                                                                                                                                
                                                                                                                                                
Sur toutes les machines :                                                                                                                                                
                                                                                                                                                
• On installe sudo si besoin, puis on crée un utilisateur « ansible ». Cet utilisateur sera celui qui effectuera les actions                                                                                                                                                 sur les machines distantes. Il n'est pas forcément nécéssaire d'en créer un sur la machine principale.                                                                                                
                                                                                                                                                
$ apt-get install sudo                                                                                                                                                
$ useradd ansible                                                                                                                                                
$ mkdir /home/ansible/.ssh && chown ansible:ansible /home/ansible/.ssh                                                                                                                                                
                                                                                                                                                
Sur le serveur ansible :                                                                                                                                                
• Connectez-vous avec l’utilisateur ansible et créez une clef SSH RSA  :                                                                                                                                                
                                                                                                                                                                                                                                                                                                
$ su ansible                                                                                                                                                                                                                                                                                                
$ cd /home/ansible/	                                                                                                                                                
$ ssh-keygen                                                                                                                                                 
                                                                                                                                                
• Maintenant, déployez la sur tous vos serveurs :                                                                                                                                                
                                                                                                                                                
$ cat .ssh/id_rsa.pub | ssh ansible@adresseServeurDistant 'cat >> .ssh/authorized_keys'                                                                                                                                                
                                                                                                                                                
Sur tous les serveurs :                                                                                                                                                
                                                                                                                                                
• Supprimez le mot de passe de l’utilisateur ansible (sauf sur la machine principale si vous désirez l'utiliser pour executer les playbooks) :                                                                                                                                                
                                                                                                                                                
$ passwd -dl ansible                                                                                                                                                
                                                                                                                                                
• Éditez le fichier des sudoers en ajoutant une ligne pour ansible à la fin du fichier :                                                                                                                                                
                                                                                                                                                
$ visudo                                                                                                                                                
> ansible ALL=(ALL) NOPASSWD: ALL                                                                                                                                                
                                                                                                                                                
• Il est aussi recommandé d'éditer le fichier sshd_config afin d'empecher les connections ssh via mot de passe et laisser uniquement la connection via clé rsa :                                                                                                                                                
                                                                                                                                                
$ vim /etc/ssh/sshd_config                                                                                                                                                 
> PasswordAuthentication no                                                                                                                                                
                                                                                                                                                
Sur la machine principale :                                                                                                                                                
                                                                                                                                                
• Vous pouvez verifier la prise de contact par :                                                                                                                                                
                                                                                                                                                
$ ansible all -m ping	                                                                                                                                                
                                                                                                                                                
• Vous pouvez dans un premier temps lancer des installations sur toutes les machines du fichier hosts par :                                                                                                                                                 
                                                                                                                                                
$ ansible all -i hosts -s -m raw -a "apt-get install -y « package »"                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
                                                                                                                                                
INSTALLATION DE SEMAPHORE (GUI) POUR ANSIBLE sur distribution Ubuntu 16.04                                                                                                                                                
                                                                                                                                                
• Pour commencer il est nécéssaire d’installer mariaDB et git depuis l’utilisateur root :                                                                                                                                                
                                                                                                                                                
$ apt-get install mariadb-server git -y                                                                                                                                                
                                                                                                                                                
• Ensuite créez un utilisateur admin qui remplacera l’utilisateur root (qui demande maintenant une auth par plugin et non plus par mot de passe sur Ubuntu …) :

$ mysql -uroot
> CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password'; (‘admin’ est une variable)                                 
> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';                                                              
> FLUSH PRIVILEGES;                                                                                             

• Ensuite, on télécharge Semaphore, on le rend executable et on lance l’installateur :

$ curl -L https://github.com/ansible-semaphore/semaphore/releases/download/v2.0.2/semaphore_linux_amd64 > /usr/bin/semaphore
$ chmod +x /usr/bin/semaphore
$ semaphore -setup

• Remplissez correctement comme indiqué ci-dessous :
> DB Hostname (default 127.0.0.1:3306): <- Enter                                                                  
> DB User (default root): admin  <- comme indiqué a l’initialisation de mysql                                 
> DB Password: password  <- Mot de passe MariaDB                                                                  
> DB Name (default semaphore):   <- Enter                                                                                                   
> Playbook path: /home/ansible/ <- Répertoire home de l’utilisateur Ansible                                                                  

• Ensuite remplissez les champs pour créer le compte principal de Semaphore

• Lancez la commande suivante pour executer Semaphore :

$ nohup semaphore -config /home/ansible/semaphore_config.json &

Si l’adresse n’a pas été changée Semaphore est maintenant accessibe avec l’url : 

localhost:3000
