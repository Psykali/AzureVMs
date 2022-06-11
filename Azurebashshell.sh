#!/bin/sh
######################################################################################################################################################                          Automation-AZURE.                                   ###                    Index Script
### Simple script to automate the installation of VMs on azure.                  ### 0.0 Starting questions.
### Azure do most of the hard work, so this script can be small-ish and lazy-ish.### 0.1 Group Creation.
###                                                                              ### 0.2 User and password-admin settings.
### WARNING: Anything not listed in the currently supported systems list is not  ### 0.3 Vnet creation:
###                                                                              ###               0.3.1- Vnet Rules
### going to work, despite the fact that you might see code that detects your    ###               0.3.2 - Loadbalancer rules
###                                                                              ### 0.4 VM Creation.
### OS and acts on it.  If it isn't in the list, the code is not complete a      ### 0.5 AZ network create.
### will not work.  More importantly, the repos that this script uses do not     ### 0.6 Creating Server Mariadb Database
### exist, if the OS isn't listed.  Don't even bother trying it.                 ###
### Version = V1 By Alain Sardin                                                 ###
### Version = V2 By KHALIFA S. 08JUNE2022                                        ###
### Version = V2.1 By KHALIFA S.                                                 ###
######################################################################################################################################################
##Starting Questions##
######################
echo "Questions Starting now"
######################################################################################################################################################
## 0.1 Group Creation ##
########################
echo ""
echo " Do you want to create a ressource group, Yes or No ?"
read Ans01
if  [ $Ans01 = Yes ]; then
echo "What do you wish to call your ressource group?!"
read group
echo "Where do you wish to create your servers?!"
read location
## Starting Group creating
az group create -g $group -l $location
    	##################
    	## condition If ##
    	##################
    	if [ "$?" -eq "0" ]; then
        		printf "Group $group at $location created, Good Job "
      	else
        		printf "%s\n" "Ouch, please correct this ( 0.1 Group Creation ) "
      	exit 1;
    	fi
    else 
     echo " no machine for you "
fi
######################################################################################################################################################
## 0.2 User and password-admin settings ##
##########################################
echo ""
echo "what do you wish to call your admin?!"
read username
echo "Please use your strongest password, if you cant create one, i invite you to try: https://passwordsgenerator.net/ "
read password
##################
## condition If ##
##################
if [ "$?" -eq "0" ]; then
    printf "Hello nice to meet you $username  "
  else
    printf "%s\n" "Ouch, please correct this ( 0.2 User and password-admin settings ) "
  exit 1;
fi
######################################################################################################################################################
## 0.3 Vnet creation ##
#######################
echo ""
#######################
## 0.3.1- Vnet Rules ##
#######################
echo " Do you want to create a Vnet , Yes or No ?"
read Ans02
if  [ $Ans02 = Yes ]; then
#echo "What you wish to call your internal Vnet?!"
#read vnetname
echo "can you please define your vnet intern IP block, exemple: 10.0.0.0/16 , 10.0.0.0/24"
read IPblockvnet
echo "can you please define your subnet IP block, exemple: 10.0.0.0/16 , 10.0.0.0/24?!"
read IPblocksubnet
## Starting Vnet creation
##une petite ligne comme  cadeau pour mon ami Salem 
az network vnet create --resource-group $group --name $group-vnet --address-prefixes '$IPblockvnet' --subnet-name $group-subnet --subnet-prefixes 'IPblocksubnet'
        ##################
        ## condition If ##
        ##################
        if [ "$?" -eq "0" ]; then
            printf "Vnet $group-vnet created, Good Job "
          else
            printf "%s\n" "Ouch, please correct this ( 0.3 Vnet creation ) "
          exit 1;
        fi
    else 
     echo " no Vnet for you "
fi
################################
## 0.3.2 - Loadbalancer rules ##
################################
echo ""
echo "Would you like to create a load-balancer, Yes or No?!"
read Ans03
if  [ $Ans03 = Yes ]; then
    az network lb create -g $group --name $group-LB --sku Standard --vnet-name $group-vnet 
        ##################
        ## condition If ##
        ##################
        if [ "$?" -eq "0" ]; then
            printf "Vnet $group-vnet created, Good Job "
          else
            printf "%s\n" "Ouch, please correct this ( 0.3.2 Vnet creation - load-balancer) "
          exit 1;
        fi
        else 
     echo " No load-balancer for you "
fi
######################################################################################################################################################
## 0.4 VM Creation ##
#####################
echo ""
echo "Would you like to create a load-balancer, Yes or No?!"
read Ans04
if  [ $Ans04 = Yes ]; then
#echo "If you wish use a VM, please entre the name?!"
#read name
echo "Which OS you wanna use for the servers?!"
read image
echo "Which servers size you like to have?!"
read serversize
echo "How many servers you wish to create?!"
read numberserver
##Starting Vms Creation
#for NUM in {1..$numberserver} 
#do
	az vm create  -g $group -n $group-VM$numberserver --public-ip-sku Standard  -l $location --image $image --admin-username $username --admin-password $password --size $serversize --count $numberserver
    #done
            ##################
            ## condition If ##
            ##################
            if [ "$?" -eq "0" ]; then
                printf "COOL, Our VM $name-$numberservers created, Good Job "
              else
                printf "%s\n" "Ouch, please correct this ( 0.4 VM Creation ) "
              exit 1;
            fi
        else 
     echo " No Vm for you "
fi
######################################################################################################################################################
## 0.5 AZ network create ##
###########################
echo ""
echo "Would you like to create a Network NSG, Yes or No?!"
read Ans05
if  [ $Ans05 = Yes ]; then
##create az network nsg
az network nsg create -g $group -n $group-nsg
##create az network nsg rules
#az network nsg rule create -g $group --nsg-name $group-$vnetname-nsg -n MyNsgRule --priority 500  --source-address-prefixes Internet --destination-port-ranges 80 443 --destination-asgs Web --access Allow --protocol Tcp --description "Allow Internet to Web ASG on ports 80,443."
#az vm open-port -g $group -n $name-$numberserver --port 80,443
        ##################
        ## condition If ##
        ##################
          if [ "$?" -eq "0" ]; then
              printf "COOL, ,az network $group-$vnetname-nsgv Good Job"
               else
               printf "%s\n" "Ouch, please correct this ( 0.5 AZ network create ) "
               exit 1;
          fi
           else 
     echo " No Network nsg for you "
fi
######################################################################################################################################################
## 0.6 Creating Server Mariadb Database ##
##########################################
echo ""
echo "Would you like to create a Server Mariadb, Yes or No?!"
read Ans06
if  [ $Ans06 = Yes ]; then
#echo "How many servers MariaDB you wish to create?!"
#read NUM02
      echo "which version of server MariaDB you wish for?!"
      read version 
      echo "Do you wish to make ssl-enforcement, Enabled ot Disabled ?!"
      read  ssl
## Server Mariadb creating
	az mariadb server create -l $location -g $group -n $group-MDB  -u $username -p $password --sku-name GP_Gen5_2 --version $version --ssl-enforcement $ssl
        ################
        ##condition If##
        ################
        if [ "$?" -eq "0" ]; then
            printf "COOL,Serveur $name-MDB created, Good Job"
                 else
            printf "%s\n" "Ouch, please correct this ( 0.6 Creating Server Mariadb Database ) "
             exit 1;
        fi
        else
  printf " Pas de serveur MariaDB"
fi
###########################################################
#echo "If you wish use an App Plan, please entre the name."
#read Planname
#echo "If you wish use an Web App, please entre the name."
#read Webappname
#########################
##Installation Finished##
#########################
echo ""
printf "COOL, Instllation Finished, You did a Good Job"
###########
##THE END##
###########
