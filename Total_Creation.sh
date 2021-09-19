#!/bin/bash
### add script line  colors 
red='\033[0;31m';
green='\033[0;32m';
blue='\033[0;34m';
light_red='\033[1;31m';
light_green='\033[1;32m';
light_blue='\033[1;34m';
NC='\033[0m';


now=$(date +"%Y%m%d");
echo "" > key_names;	#delete any previous keys
cp -r template  backup-template/item/$now-$item_name; #backupfile


########################
#### get Template name from template file
Template_name=$(grep -oP '(?<=<template>).*(?=</template>)' template);
echo "$Template_name ";
########################

. /zabbix/zabbix/Create_item.sh 


########################################################################################################
############################   Graph Creation 		###############################################
#######################################################################################################

echo "
	Would you like to Create a graph for the Predefined keys y or n ?

"
read response;

if [[ $response == "y" ]] ;then


. /zabbix/zabbix/Create_graph.sh

fi

 
##############################################################################
###################### Create Triggers   ################################
###################################################################### 

echo "
        Would you like to Create a Trigger y or n ?

"
read trigger_response;

  if [[ $trigger_response == "y" ]] ;
  then
. /zabbix/zabbix/Create_trigger.sh
  fi

