#!/bin/bash
<<<<<<< HEAD
################
### enter Graph Name

echo "$reverse Please enter Graph Name $NC"
read graph_name;

## Create Keys 

IFS=$'\n' read -d '' -r -a lines <  /zabbix/zabbix/files/service/keys_only      # read key file ${#lines[@]} ==> number fo lines in file

for (( i = 0 ; i < ${#lines[@]} ; i++)); do


##### enter color value

echo -e "Please, choose ${lines[$i]}  color

	1) $red Red $NC
	2) $green Green $NC
	3) $blue Blue $NC
	4) $light_red Ligt Red $NC
	5) $light_green Light Green $NC
 	6) $light_blue Light Blue $NC";
while :
	do 
	read color_num
	case $color_num in
	   1)
		color="BB0000"    #"990000"
		break
		;;
           2)
                color="00AA00"  	#009900"
                break
                ;;
           3)
                color="0000BB"	#"000077"
                break
                ;;
           4)
                color="EE0000"		#"EE0000"
                break
                ;;
           5)
                color="00DD00"	#"00DD00"
                break
                ;;
           6)
                color="0000EE"	#"3333FF"	
                break
                ;;
           q)
                exit 1
		;;
           *)
	        echo -e "please choose correct number.\n "
		;;
	
	esac
done 


key="
              <graph_item>
                    <sortorder>$i</sortorder>
                    <drawtype>0</drawtype>
                    <color>$color</color>
                    <yaxisside>0</yaxisside>
                    <calc_fnc>2</calc_fnc>
                    <type>0</type>
                    <item>
                        <host>$Template_name</host>
                        <key>${lines[$i]}</key>
                    </item>
               </graph_item>
";

echo " $key " >> tmp.file
done
keys=$( cat tmp.file);

##############
### Create The whole graph 
=======
clear;
echo "Please enter Graph Name"
read graph_name;


echo "Please enter the key Name"
read key_name;

now=$(date +"%Y%m%d");
>>>>>>> 0909eb507c2ae42777f4bd5d0c77791de12459b8


graph="
<graph>
            <name>$graph_name</name>
            <width>900</width>
            <height>200</height>
            <yaxismin>0.0000</yaxismin>
            <yaxismax>100.0000</yaxismax>
            <show_work_period>1</show_work_period>
            <show_triggers>1</show_triggers>
            <type>0</type>
            <show_legend>1</show_legend>
            <show_3d>0</show_3d>
            <percent_left>0.0000</percent_left>
            <percent_right>0.0000</percent_right>
            <ymin_type_1>0</ymin_type_1>
            <ymax_type_1>0</ymax_type_1>
            <ymin_item_1>0</ymin_item_1>
            <ymax_item_1>0</ymax_item_1>
            <graph_items>
<<<<<<< HEAD
		$keys 
            </graph_items>
</graph>
";
#############


#echo "$graph";

if  grep  "graph_name" template  ; then
         echo "
$red This Item is already Created $NC";
         rm -rf tmp.file;

else
        echo " $graph" > files/graph_file;
  	echo " $graph" >> logs/graphs/$now; #logfile 
        sed -i  -e'/^<graphs>/ { r files/graph_file' -e '; :L; n; bL;}'  template;
        echo "
	             
 __       _                                         __                  
/__ __ _ |_)|_  _    |_  _     _    |_  _  _ __    /   __ _  _ _|_ _  _|
\_| | (_||  | |_>    | |(_|\_/(/_   |_)(/_(/_| |   \__ | (/_(_| |_(/_(_|


 ";
	 rm -rf tmp.file;
=======
                <graph_item>
                    <sortorder>0</sortorder>
                    <drawtype>0</drawtype>
                    <color>1A7C11</color>
                    <yaxisside>0</yaxisside>
                    <calc_fnc>2</calc_fnc>
                    <type>0</type>
                    <item>
                        <host>test</host>
                        <key>$key_name</key>
                    </item>
                </graph_item>
            </graph_items>
</graph>
";
if  grep  "graph_name" template  ; then
         echo "This Item is already Created";
else
        echo " $graph" > graph_file;
         cp -r template  backup-template/graph/$now-$graph_name; #backupfile
  	echo " $graph" > logs/graphs/$now-$graph_name; #logfile 
        sed -i  -e'/^<graphs>/ { r graph_file' -e '; :L; n; bL;}'  template;
        echo "
		Graph Has been added to Template File
	              Please Run impot.yml";
>>>>>>> 0909eb507c2ae42777f4bd5d0c77791de12459b8
fi

