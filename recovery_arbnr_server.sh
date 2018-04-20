#!/bin/bash
MONITOR_SUCCESS_PORTS=(50214 50224 50234 50244 50254 50264 50274 50284 50294 50204)
ARBNR_SERVER_PORTS=(50212 50222 50232 50242 50252 50262 50272 50282 50292 50202)
function find_monitor_success_ports ()
{
     #ports=$1
     ports=("$@")
     p=0
     for port in ${ports[@]} ;
     do
         netcat 192.168.1.94 "$port" -w 1
         if [[ "$?" = "0" ]] ; then
             p="$port"
             break
         fi
     done
     echo $p
}
function find_empty_ports ()
{
     ports=("$@")
     p=0
     for port in ${ports[@]} ;
     do
         netstat -ant tcp|grep "$port">/dev/null
         if [ "$?" == "1" ] ; then
             p="$port"
             break
         fi
     done
     echo $p
}
echo "1">/home/uninet/arbnr_recovery.dat
while true; do
   n=$(cat /home/uninet/arbnr_recovery.dat)
   if [ $n == "1" ] ; then
       echo -e "\e[32mDetect monitor_success server port.\e[0m"
       monitor_success_port=$(find_monitor_success_ports ${MONITOR_SUCCESS_PORTS[@]})
       arbnr_server_port=$(find_empty_ports ${ARBNR_SERVER_PORTS[@]})
       if [ "$monitor_success_port" = "0" ] ; then
           echo -e "\e[31mCouldn't find the port that monitor_success open\e[0m"
           continue
       fi
       if [ "$arbnr_server_port" = "0" ] ; then
           echo -e "\e[31mCouldn't find port that can be opened for arbnr_server\e[0m"
           continue
       fi 
       echo -e "\e[32mmonitor_success_port=" $monitor_success_port ",arbnr_server_port=" $arbnr_server_port "\e[0m"
       cd /home/uninet/pic
       sed   "s/inner_port/${arbnr_server_port}/;s/monitor_port/${monitor_success_port}/" ocr.ini.template>ocr.ini
       ./arbnr_server
       cd /home/uninet/
   else 
       echo -e "\e[32mclose arbnr_server\e[0m"
       break
   fi  

done
