#!/bin/bash 
clear

red='\033[0;31m';
green='\033[0;32m';
blue='\033[0;34m';
light_red='\033[1;31m';
light_green='\033[1;32m';
light_blue='\033[1;34m';
NC='\033[0m';
underline="\033[4m";
reverse="\033[7m";
BBlack='\033[1;30m'

echo -e  "
				======================================================================================================================================== 
				=  ====  ====  =========  =========================================  ==================================        =========================
				=  ====  ====  =========  ========================================    ====================================  ============================
				=  ====  ====  =========  =======================================  ==  ===================================  ============================
				=  ====  ====  ===   ===  ===   ====   ===  =  = ====   ========  ====  ==  =  = ====   ===  = ===========  ======   ====   ===  =  = ==
				=   ==    ==  ===  =  ==  ==  =  ==     ==        ==  =  =======  ====  ==        ==  =  ==     ==========  =====  =  ==  =  ==        =
				==  ==    ==  ===     ==  ==  =====  =  ==  =  =  ==     =======        ==  =  =  =====  ==  =  ==========  =====     =====  ==  =  =  =
				==  ==    ==  ===  =====  ==  =====  =  ==  =  =  ==  ==========  ====  ==  =  =  ===    ==  =  ==========  =====  ======    ==  =  =  =
				===    ==    ====  =  ==  ==  =  ==  =  ==  =  =  ==  =  =======  ====  ==  =  =  ==  =  ==  =  ==========  =====  =  ==  =  ==  =  =  =
				====  ====  ======   ===  ===   ====   ===  =  =  ===   ========  ====  ==  =  =  ===    ==  =  ==========  ======   ====    ==  =  =  =
				========================================================================================================================================
                                $light_green 
					 _______ _______  ______ _    _ _____ _______ _______      _______ _______  ______ _______ _______ _____  _____  __   _
					 |______ |______ |_____/  \  /    |   |       |______      |       |______ |_____/ |_____|    |      |   |     | | \  |
					 ______| |______ |    \_   \/   __|__ |_____  |______      |_____  |______ |    \_ |     |    |    __|__ |_____| |  \_|
	                                                                                                                       $NC
						$light_blue		This Script Used for Automating  Service Creation on zabbix server
										Key | Query |Items | Graphs | Triggers $NC

												
"


##### backup orrabix file 
now=$(date +"%Y%m%d");
file_check=$(ls /opt/orabbix/conf/backup/ | grep $now-query_fe.prop );
if [[  $file_check == "" ]]; then
cp /opt/orabbix/conf/query_fe.props /opt/orabbix/conf/backup/$now-query_fe.props
fi

####### Delete any previous data for keys | queries 
rm -rf  files/service/keys.prob
rm -rf  files/service/keys
rm -rf  files/service/query
rm -rf  files/service/keys_only

############# Create query and Key 
cont=n
while [ "$cont" != "y" ]
do
echo -e  "$reverse
could you please enter service id 
$NC "
read service_id 
echo -e "$reverse
could you please enter service name 
$NC"
read service_name
echo $service_name >> files/service/keys
echo "accpted "$service_name >> files/service/keys
echo "refused "$service_name >> files/service/keys
new_service_name=$(echo $service_name | tr " " _) ## convert any white space in name to _ 
new_service_name=$(echo $new_service_name | tr "(" _)
new_service_name=$(echo $new_service_name | tr ")" _)
#echo $service_name >> keys
accept_service_name="curr_trans_accepted_$new_service_name"
echo $accept_service_name >> files/service/keys_only
echo $accept_service_name >> files/service/keys
refused_service_name="curr_trans_refused_$new_service_name"
echo $refused_service_name >> files/service/keys_only
echo $refused_service_name >> files/service/keys
echo "###############################" >> files/service/keys
echo "################ $service_name ###############################" >> files/service/query 
accept_query="$accept_service_name"".Query=SELECT count(*)  \
     FROM svista.curr_trans c , (select count(REVERSAL)  as  REVERSAL  , UTRNNO FROM svista.CURR_TRANS CURR_TRANS where \ CURR_TRANS.udate=TO_NUMBER(TO_CHAR(sysdate, 'YYYYMMDD'))    \
    AND RESP = -1  group by UTRNNO) reversal  \
    WHERE udate=TO_NUMBER(TO_CHAR(sysdate, 'YYYYMMDD'))  \
    AND TO_CHAR((c.udate) || LPAD(c.time, 6, 0)) \
	BETWEEN TO_CHAR(sysdate - 1/(24*60),'YYYYMMDDHH24MISS') AND TO_CHAR(sysdate, 'YYYYMMDDHH24MISS')  \
	AND RESP = -1  AND reversal.REVERSAL = 1   AND reversal.utrnno=c.utrnno  AND  c.UDATE=TO_NUMBER(TO_CHAR(sysdate, 'YYYYMMDD')) \
    AND sv_core.Get_string_data(sv_core.Get_tag_data_f(205,bpc_addldata))  = $service_id"
echo $accept_query >> files/service/query	
	
refused_query="$refused_service_name"".Query=select  count(distinct(ct.UTRNNO)) from SVISTA.CURR_TRANS ct where (ct.reversal=1 or ct.resp !=-1) and ct.udate = TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMMDD')) AND TO_CHAR ((ct.udate) || LPAD (ct.time, 6, 0)) BETWEEN TO_CHAR (SYSDATE-   1/ (  24* 60),'YYYYMMDDHH24MISS') AND TO_CHAR (SYSDATE,'YYYYMMDDHH24MISS') and sv_core.Get_string_data(sv_core.Get_tag_data_f(205,bpc_addldata)) =  $service_id 
"
echo $refused_query >> files/service/query
echo "################################################################" >> files/service/query 
echo -e "$reverse
do you wanna exit y or n
$NC"
read cont
done
#tr '\n' ',' < keys_only >> keys.prob
sed -e  's/^/,/'  files/service/keys_only   | paste -sd "" >> files/service/keys.prob


#############
##### add keys and query to
 
while read line ;do
sed -i -e  "/QueryList/ s/$/$line/" /opt/orabbix/conf/query_fe.props
done < /zabbix/zabbix/files/service/keys.prob


#####  add query to query file 
cat files/service/query >> /opt/orabbix/conf/query_fe.props;


#### check to create item | graph | trigger 
echo -e  "$reverse
Would you like to create Item 
$NC"
read response 

if [[ $response == "y"  ]] ; then

/zabbix/zabbix/Total_Creation.sh 
fi


#echo "your query is ready in file called query " 
#echo "your keys is ready in file called in file key.probs" 

echo -e "


                                                                                             
					      * ***                                 **            ***** **                           
					    *  ****  *                               **        ******  ***                           
					   *  *  ****                                **       **   *  * **                           
					  *  **   **                                 **      *    *  *  **                           
					 *  ***             ****       ****          **          *  *   *    **   ****               
					**   **            * ***  *   * ***  *   *** **         ** **  *      **    ***  *     ***   
					**   **   ***     *   ****   *   ****   *********       ** ** *       **     ****     * ***  
					**   **  ****  * **    **   **    **   **   ****        ** ***        **      **     *   *** 
					**   ** *  ****  **    **   **    **   **    **         ** ** ***     **      **    **    ***
					**   ***    **   **    **   **    **   **    **         ** **   ***   **      **    ******** 
					 **  **     *    **    **   **    **   **    **         *  **     **  **      **    *******  
					  ** *      *    **    **   **    **   **    **            *      **  **      **    **       
					   ***     *      ******     ******    **    **        ****     ***    *********    ****    *
					    *******        ****       ****      *****         *  ********        **** ***    ******* 
					      ***                                ***         *     ****                ***    *****  
		                                                     *                  *****   ***          
					                                                      **              ********  **           
			                                		                                     *      ****             
       		                                                                           
							$light_blue		 Copyright © 2021  saad aleraqy    $NC
"
