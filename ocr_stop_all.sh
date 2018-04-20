while [ 1 ]; do
    echo -e "\e[31mDo you close all CheckFolder.exe?(y/n)\e[0m"
    read ans
    if [[ $ans == "y" ]] ; then
        break
    fi
done
while [ 1 ];do
    echo -e "\e[31mDo you close all Recognition.exe?(y/n)\e[0m"
    read ans
    if [[ $ans == "y" ]] ;then
        break
    fi
done
while [ 1 ]; do
    echo -e "\e[31mDo you close the server in 192.168.1.93?(y/n)\e[0m"
    read ans
    if [[ $ans == "y" ]] ; then
        break
    fi
done
echo "0">/home/uninet/client_monitor_recovery.dat
pgrep client_picture|xargs -I{}  kill -9 {}
sleep 1.0
#Use in Ftp transmission mode
#pgrep dispatch_pict|xargs -I{}  kill -9 {}
#sleep 1.0
pgrep pic_dispatch|xargs -I{} kill -9 {}
sleep 1.0
#----------------------------------------------
echo "0">/home/uninet/arbnr_recovery.dat
pgrep arbnr_server|xargs -I{}  kill -9 {}
sleep 1.0
echo "0">/home/uninet/monitor_success_recovery.dat
pgrep monitor_success|xargs -I{}  kill -9 {}
sleep 1.0
echo "0">/home/uninet/monitor_fail_monitor.dat
pgrep picture_monitor|xargs -I{} kill -9 {}
sleep 1.0
tmux kill-session -t ocr
