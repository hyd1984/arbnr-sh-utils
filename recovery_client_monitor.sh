#!/bin/bash
echo "1">/home/uninet/client_monitor_recovery.dat
function restore_pics()
{
     file_list=($(ls -t *.jpg|tac))
     sleep 4
     for f in ${file_list[@]};
     do
         sleep 0.5
         cp $f /home/uninet/dispatch/
     done         
}
while true; do
   n=$(cat /home/uninet/client_monitor_recovery.dat)
   if [ $n == "1" ] ; then
       pgrep arbnr_server
       if [ $? == 0 ] ; then
           echo -e "\e[32mDetect arbnr_server port.\e[0m"
           arbnr_port=$(netstat -tulpn|grep arbnr_server|awk '{print $4}'|awk -F: '{print $2}')
           echo -e "\e[32marbnr_port=" $arbnr_port "\e[0m"
           if [ "$arbnr_port" = "0" ] ;then
     #          sleep 1
               continue
           fi
           cd /home/uninet/pic
           sed "s/recognition_port/${arbnr_port}/" pm.ini.template>pm.ini
#           restore_pics &
           ./client_picture_monitor.x
           cd /home/uninet
           arbnr_port="0"
      #     sleep 1
       else
           echo -e "\e[31mCannot link to arbnr_server\[0m"
           sleep 1
       fi
   else
       echo -e "\e[32mclose client_picture_monitor.x\[0m"
       sleep 1
       break
   fi

done

