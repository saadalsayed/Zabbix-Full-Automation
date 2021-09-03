#!/bin/bash
echo "Please Enter Item Name";
read item_name;


echo "Please Enter Key Name";
read key_name; 

item="
<item>
                    <name>$item_name</name>
                    <type>0</type>
                    <snmp_community/>
                    <snmp_oid/>
                    <key>$key_name</key>
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


if  grep  "$item_name" template  ; then
 	 echo "This Item is already Created";
else
 	echo " $item " > item_file;
 	sed -i 21ritem_file  template;
	echo "Item Has been added to Template File";
fi






