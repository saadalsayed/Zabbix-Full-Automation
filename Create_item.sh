#!/bin/bash
<<<<<<< HEAD

IFS=$'\n' read -d '' -r -a lines < /zabbix/zabbix/files/service/keys_only    # read key file ${#lines[@]} ==> number fo lines in file

for (( i = 0 ; i < ${#lines[@]} ; i++)); do


echo -e "$reverse Please Enter Item Name for key,${lines[$i]} $NC";
read item_name;

=======
clear;
echo "Please Enter Item Name";
read item_name;


echo "Please Enter Key Name";
read key_name; 

now=$(date +"%Y%m%d");
>>>>>>> 0909eb507c2ae42777f4bd5d0c77791de12459b8

item="
<item>
                    <name>$item_name</name>
                    <type>0</type>
                    <snmp_community/>
                    <snmp_oid/>
<<<<<<< HEAD
                    <key>${lines[$i]}</key>
=======
                    <key>$key_name</key>
>>>>>>> 0909eb507c2ae42777f4bd5d0c77791de12459b8
                    <delay>30s</delay>
                    <history>90d</history>
                    <trends>365d</trends>
                    <status>0</status>
                    <value_type>3</value_type>
                    <allowed_hosts/>
                    <units/>
                    <snmpv3_contextname/>
                    <snmpv3_securityname/>
                    <snmpv3_securitylevel>0</snmpv3_securitylevel>
                    <snmpv3_authprotocol>0</snmpv3_authprotocol>
                    <snmpv3_authpassphrase/>
                    <snmpv3_privprotocol>0</snmpv3_privprotocol>
                    <snmpv3_privpassphrase/>
                    <params/>
                    <ipmi_sensor/>
                    <authtype>0</authtype>
                    <username/>
                    <password/>
                    <publickey/>
                    <privatekey/>
                    <port/>
                    <description/>
                    <inventory_link>0</inventory_link>
                    <applications/>
                    <valuemap/>
                    <logtimefmt/>
                    <preprocessing/>
                    <jmx_endpoint/>
                    <master_item/>
</item>
";

<<<<<<< HEAD
check_item=$( sed -n '/[<]item[>]/,/[</]item[>]/p' template |   grep -oP '(?<=<name>).*(?=</name>)' template  |grep -w "$item_name")

  if [[ $check_item == $item_name ]]   ; then
 	 echo -e  "
$red This Item is already Created $NC ";
  else
 	echo " $item " > files/item_file;
	 echo " $item " >> /zabbix/zabbix/logs/item/$now;  #logfile
 	sed -i 21rfiles/item_file  template;
   fi

done
echo "
___                                              __                  
 | _|_ _ __  _    |_  _     _    |_  _  _ __    /   __ _  _ _|_ _  _|
_|_ |_(/_|||_>    | |(_|\_/(/_   |_)(/_(/_| |   \__ | (/_(_| |_(/_(_|

"
=======

if  grep  "$item_name" template  ; then
 	 echo "This Item is already Created";
else
 	echo " $item " > item_file;
        cp -r template  backup-template/item/$now-$item_name; #backupfile
	 echo " $item " > logs/item/$now-$item_name;  #logfile
 	sed -i 21ritem_file  template;
	echo "
		Item Has been added to Template File
  		      Please run import.yml";
fi
>>>>>>> 0909eb507c2ae42777f4bd5d0c77791de12459b8
