#!/bin/bash
pgrep mysqld >/dev/null
if [[ $? == 0 ]]; then
   echo -e "\e[32mMysql server is running!\e[0m"
else
   echo -e "\e[31mMysql server is not running!!\e[0m"
   exit
fi
echo "Check mysqld setting is correct"
mysql -sN --host=127.0.0.1 --user=eventpal -p --port=3306 --execute="select 1 from dual">/dev/null
if [[ $? == 0 ]]; then
    echo -e "\e[32mMysql setting is correct!\e[0m"
else
    echo -e "\e[31mMysql setting is incorrect!\e[0m"
fi
echo "Check smbd is running."
pgrep smbd >/dev/null
if [[ $? == 0 ]]; then
   echo -e "\e[32msamba server is running!!\e[0m"
else
   echo -e "\e[31msamba server is not running!!\e[0m"
   exit
fi
pgrep client_picture>/dev/null
if [[ $? == 0 ]]; then
    echo -e "\e[32mclient_picture_monitor.x is running.\e[0m"
else
    echo -e "\e[31mclient_picture_monitor.x is not running.\e[0m"
fi 
pgrep arbnr_server>/dev/null
if [[ $? == 0 ]]; then
    port=$(netstat -antlp tcp|grep arbnr_server|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
    echo -e "\e[32marbnr_server is running,port is ${port}.\e[0m"
else
    echo -e "\e[31marbnr_server is not running.\e[0m"
fi
pgrep monitor_success>/dev/null
if [[ $? == 0 ]]; then
   port=$(netstat -antlp tcp|grep monitor_succe|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
   echo -e "\e[32mmonitor_success is running,port is ${port}.\e[0m"
else
   echo -e "\e[31mmonitor_success is not running.\e[0m"
fi

pgrep pic_dispatcher > /dev/null
if [[ $? == 0 ]]; then
   port=$(netstat -antlp tcp|grep pic_disp|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
   echo "pic_dispatcher is running,port is ${port}."
else
   echo "pic_dispatcher is not running."
fi

pgrep picture_monitor >/dev/null

if [[ $? == 0 ]]; then
   port=$(netstat -antlp|grep picture_monit|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
   echo -e "\e[32mpicture_monitor.x is running,port is ${port}.\e[0m"
else
   echo -e "\e[31mpicture_monitor.x is not running.\e[0m"
fi
ls /home/uninet/pic1/this_is_93.txt>/dev/null
if [[ $? == 0 ]]; then
   echo -e "\e[32msamba mount to 93 is worked.\e[0m"
else
   echo -e "\e[31msamba mount to 93 is not worked.\e[0m"
fi

ssh user@192.168.1.93 "sh test_ftp.sh"
ls /home/uninet/aaaaaa.txt>/dev/null
if [[ $? == 0 ]]; then
   echo -e "\e[32mftp on 94 worked.\e[0m"
   rm /home/uninet/aaaaaa.txt
else
   echo -e "\e[31mftp on 94 not worked.\e[0m"
fi

echo "monitor_success link:"
netstat -ant tcp | grep ESTABLISHED |awk '$4 ~/.*:502[0123456789]4/ {print "    " $5}'
echo "pic_dispatcher link:"
netstat -ant tcp|grep ESTABLISHED |awk '$4 ~/.*:502[0123456789]1/ {print "    " $5}'
echo "arbnr_server link:"
netstat -ant tcp|grep ESTABLISHED |awk '$4 ~/.*:502[0123456789]2/ {print "    " $5}'
echo "fail picture_monitor.x link:"
netstat -ant tcp|grep ESTABLISHED|awk '$4 ~/.*:502[0123456789]3/ {print "    " $5}'


