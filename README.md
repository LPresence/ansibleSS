# ansibleSS
Sopra Steria                                                                                                                               
Durant mon stage chez Sopra Steria j'apprend à maitriser ansible                                                           
Suivez mon aventure ici http://stage.lukaspresencia.fr

-------------------------------------------------------------------------------------------------------------------------------------------

Sopra Steria                                                                                                                              
I'm trying to do something useful of ansible for my internship at Sopra Steria                                                           
Follow my adventures here http://stage.lukaspresencia.fr

------------------------------------------------------------------------------------------------------------------------------------------- 
                                                            
install.md : explain how to install Ansible and Semaphore (GUI)                                                                 

Linux :

addServer.sh : bash script simplifying the ssh key exchange from the host and the machines                                                            
main.yml : update and install apache2 on linux hosts using aptitude, needs the related yml from roles/tasks                                                                                                                      
setup_tools.yml : install a list of packages with apt on the hosts                                                                                                                      
jboss-as.yml : install a fully configurable jboss application server instance on CentOs hosts, needs jboss_mgn_user.yml                                                                                                                      
jboss-mgmt-usr.yml : create a jboss management user, need to use a java class to encrypt the password                              
jbossAnApp.yml : deploy an application on a Jboss server                                                                                          
openshift_hosts : host file for installing openshift                                                                                  
Jboss-asV1/2.yml : just some previous versions of jboss-as.yml                                                                                  

Windows :

WinRMcfg.ps1 : Windows script to configure a Windows host for remote management with Ansible                                                        
disableUAC.yml : disable the User Account Control of Windows for a local account                                                                                                                                     
justSendFile.yml : send a file from the host to the Windows                                                                                                                                                          
MSSQLExpress.yml : install Microsoft SQL Express on windows                                                                                                                                                          
showyourwebsite.yml : activate windows IIS with management tools and setup a html page on windows hosts                                                                          
install_zabbix: install on windows a zabbix agent used for monitoring services                                                                                          

