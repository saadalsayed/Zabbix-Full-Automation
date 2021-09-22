#!/bin/bash

IFS=$'\n' read -d '' -r -a lines < /zabbix/zabbix/files/service/keys_only    # read key file ${#lines[@]} ==> number fo lines in file

for (( i = 0 ; i < ${#lines[@]} ; i++)); do


echo -e "$reverse Please Enter Item Name for key,${lines[$i]} $NC";
read item_name;

### check if there is an item with the same item name
check_item=$( sed -n '/[<]item[>]/,/[</]item[>]/p' template |   grep -oP '(?<=<name>).*(?=</name>)' template  |grep -w "$item_name" | grep -v -e '^[[:space:]]*$ ')

 while [[  "$check_item" != ""  ]]   ;do

 echo -e  "
$red This Item is already Created $NC ";

echo -e "$reverse Please Enter Item Name for key,${lines[$i]} $NC";
read item_name;

check_item=$( sed -n '/[<]item[>]/,/[</]item[>]/p' template |   grep -oP '(?<=<name>).*(?=</name>)' template  |grep -w "$item_name" | grep -v -e '^[[:space:]]*$ ')

done

now=$(date +"%Y%m%d");

item="
<item>
                    <name>$item_name</name>
                    <type>0</type>
                    <snmp_community/>
                    <snmp_oid/>
                    <key>${lines[$i]}</key>
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


 	echo " $item " > files/item_file;
	 echo " $item " >> /zabbix/zabbix/logs/item/$now;  #logfile
 	sed -i 21rfiles/item_file  template;


done
echo "
___                                              __                  
 | _|_ _ __  _    |_  _     _    |_  _  _ __    /   __ _  _ _|_ _  _|
_|_ |_(/_|||_>    | |(_|\_/(/_   |_)(/_(/_| |   \__ | (/_(_| |_(/_(_|

"
