
#!/bin/bash

## enter the trigger name 

IFS=$'\n' read -d '' -r -a lines < /zabbix/zabbix/files/service/keys_only    # read key file ${#lines[@]} ==> number fo lines in file

for (( i = 0 ; i < ${#lines[@]} ; i++)); do

echo "$reverse Please Enter Trigger Name for key ${lines[$i]} $NC ";
read trigger_name;
########################
########################
## Choose the comparing value 
echo " - Please Choose the Operator  (press q to Quit)
              1)=
              2)>
              3)<
              4)NOT";
while :
    do
    read number
    case $number in
            1)
               value="="
               break
               ;;
            2)
	       value="&gt;"
               break
               ;;
            3)
               value="&lt;"
               break
               ;;
            4)
               value="&lt;&gt"
               break
               ;;
            q)
               exit 1
               ;;
            *)
               echo -e "please choose correct number.\n"
               ;;
    esac
done
########################

########################
## choose Severity
echo "- Please choose the Severity (Press q to Quit)

	1) Not classified
	2) Information
	3) Warrning
      	4) Average
	5) High
	6) Disaster";

while :
  do
   read severity
   case $severity in 
     1) 
 	priority="0"
	break
	;;
     2) 
        priority="1"
        break
        ;;
     3)
        priority="2"
        break
        ;;
     4)
        priority="3"
        break
        ;;
     5)
        priority="4"
        break
        ;;
     6)
        priority="5"
        break
        ;;
     q)
       exit
  	;;

     *)
       echo -e "please choose correct number.\n"
       ;;

  esac
done
########################        
	
########################
### adding the comparing amount 
echo "Please Enter The Amount ";
read amount;
########################

########################
#Create the trigger XML Template
trigger="

	<trigger>
            <expression>{$Template_name:${lines[$i]}.last()}$value$amount</expression>
            <recovery_mode>0</recovery_mode>
            <recovery_expression/>
            <name>$trigger_name</name>
            <correlation_mode>0</correlation_mode>
            <correlation_tag/>
            <url/>
            <status>0</status>
            <priority>$priority</priority>
            <description/>
            <type>0</type>
            <manual_close>0</manual_close>
            <dependencies/>
            <tags/>
	</trigger>

";

######Check if this trigger created before with the same expression or not 
check=$(sed -n '/[<]triggers[>]/,/[</]triggers[>]/p' template |   grep -oP '(?<=<expression>).*(?=</expression>)');
#echo " $check ";
########################


########################
#Copy triger XML to template file if not created before
  if [[ $check == "{$Template_name:${lines[$i]}.last()}$value$amount" ]] ; then
 	 echo " 
$red This trigger is already Created Before With the same Expression $NC";
   else
 	echo " $trigger " > files/trigger_file;
	 echo " $trigger " >> logs/trigger/$now;  #logfile
        sed -i  -e'/^<triggers>/ { r files/trigger_file' -e '; :L; n; bL;}'  template;
   fi
done 

echo "
___       _  _                                            __                  
 |  __ o (_|(_| _  __ _    |_  _     _    |_  _  _ __    /   __ _  _ _|_ _  _|
 |  |  | __|__|(/_ | _>    | |(_|\_/(/_   |_)(/_(/_| |   \__ | (/_(_| |_(/_(_|

";
