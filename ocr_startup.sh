#!/bin/bash
sn=ocr
echo "Check mysqld is running."
test_server_alive () 
{
    pgrep $1 >/dev/null
    if [[ $? == 0 ]] ; then
        echo -e "\e[32m$1 server is running!\e[0m"
    else
        echo -e "\e[31m$1 server is not running!!\e[0m"
    fi
}
test_server_alive mysqld
#pgrep mysqld >/dev/null
#if [[ $? == 0 ]]; then
#   echo -e "\e[32mMysql server is running!\e[0m"
#else
#   echo -e "\e[31mMysql server is not running!!\e[0m"
#   exit
#fi
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
echo "Check Branch to 93."
ls /home/uninet/pic1/this_is_93.txt >/dev/null
if [[ $? == 0 ]]; then
   echo -e "\e[32mYou can branch the pictures to 93!\e[0m"
else
   echo -e "\e[31mYou cannot branch the pictures to 93!\e[0m"
   exit
fi

pgrep client_picture>/dev/null
if [[ $? == 0 ]]; then
    echo "client picture monitor is running."
    exit
fi
#Use in ftp transmission mode--------------------------------
pgrep dispatch_pict>/dev/null
if [[ $? == 0 ]]; then
    echo "dispatch picture monitor is running."
    exit
fi
#----------------------------------------
pgrep arbnr_server>/dev/null
if [[ $? == 0 ]]; then
    echo "ocr_server is running."
    exit
fi
pgrep monitor_success>/dev/null
if [[ $? == 0 ]]; then
   echo "monitor_success is running."
   exit
fi
pgrep pic_dispatcher >/dev/null
if [[ $? == 0 ]]; then
   echo "pic_dispatcher is running."
   exit
fi
pgrep picture_monitor.x > /dev/null
if [[ $? == 0 ]]; then
   echo "picture_monitor.x is running."
   exit
fi
#----------------------------------------------------------------------
echo -e "Start up pic_dispatch.sh"
tmux new-session -s "$sn"   -d -n "dispatch"
tmux send-keys -l "cd /home/uninet/dispatch"
tmux send-keys C-m
tmux send-keys -l "./pic_dispatch.sh"
tmux send-keys C-m
sleep 1.5

#pgrep pic_dispatcher>/dev/null
#if [[ $? == 0 ]]; then
   #port=$(netstat -antlp tcp|grep pic_disp|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
   #echo -e "\e[32mpic_dispatcher is running,port is ${port}.\e[0m"
#else
   #echo -e "\e[31mpic_dispatcher is not running.\e[0m"
   #exit
#fi
#----------------------------------------------------------------------------------------------


echo "Start up monitor_success"
tmux new-window -t "$sn:1" -n "success" 
#tmux send-keys -l "cd /home/uninet/success"
#tmux send-keys C-m
tmux send-keys -l "./recovery_monitor_success.sh"
tmux send-keys C-m
sleep 1.5

pgrep monitor_success >/dev/null
if [[ $? == 0 ]]; then
    port=$(netstat -antlp tcp|grep monitor_succe|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
    echo -e "\e[32mmonitor_succes is running,port is ${port}.\e[0m"
else
    echo -e "\e[31mmonitor_success is not executing.\e[0m"
    exit
fi

echo "Start up arbnr_server"
tmux new-window -t "$sn:2" -n "arbnr_server"
#tmux send-keys -l "cd /home/uninet/pic"
#tmux send-keys C-m
tmux send-keys -l "./recovery_arbnr_server.sh"
tmux send-keys C-m

sleep 1.5
pgrep arbnr_server >/dev/null
if [[ $? == 0 ]]; then
    port=$(netstat -antlp tcp|grep arbnr_server|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
    echo -e "\e[32marbnr_server is running,port is ${port}.\e[0m"
else
    echo -e "\e[31marbnr_server is not running.\e[0m"
    exit
fi

echo "Start up client_picture_monitor.x"
tmux new-window -t "$sn:3" -n "client_monitor"
#tmux send-keys -l "cd /home/uninet/pic"
#tmux send-keys C-m
tmux send-keys -l "./recovery_client_monitor.sh"
tmux send-keys C-m
sleep 1.5
pgrep client_picture> /dev/null
if [[ $? == 0 ]]; then
     echo -e "\e[32mclient_picture_monitor.x is running.\e[0m"
else 
     echo -e "\e[31mclient_picture_monitor.x  is not running.\e[0m"
     exit
fi
echo "Start up picture_monitor.x in fail directory."
tmux new-window -t "$sn:4" -n "fail_monitor"
#tmux send-keys -l "cd /home/uninet/fail"
#tmux send-keys C-m
tmux send-keys -l "./recovery_fail_monitor.sh"
tmux send-keys C-m
sleep 1.5
pgrep picture_monitor >/dev/null
if [[ $? == 0 ]]; then
    port=$(netstat -antlp|grep picture_monit|grep LISTEN|awk '{print $4}'|awk -F: '{print $2}')
    echo -e "\e[32mpicture_monitor.x is running,port is ${port}.\e[0m"
else
    echo -e "\e[31mpicture_monitor.x in fail is not executing.\e[0m"
    exit
fi

#Use in ftp transmission mode-----------------------------
#----------------------------------------------------------

echo -e "\e[32mYour can startup Recognition.exe in /home/uninet/fail\e[0m"
echo -e "\e[32mYou can startup CheckFolder.exe\e[0m"
#cd /home/uninet/pic
#tmux new-window -t "$sn:3" -n "pic_monitor" 
#sleep 2
tmux detach -s "$sn"
if [ -f "/tmp/record_time.txt" ] ; then
rm /tmp/record_time.txt
fi
