#!/bin/bash
MONITOR_FAIL_PORTS=(50213 50223 50233 50243 50253 50263 50273 50283 50293 50203)
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
echo "1">/home/uninet/monitor_fail_monitor.dat
while true ; do
    n=$(cat /home/uninet/monitor_fail_monitor.dat)
    if [ $n == "1" ] ; then
        echo -e "\e[32mFind unuse port.\e[0m"
        port=$(find_empty_ports ${MONITOR_FAIL_PORTS[@]})
        if [ "$port" = "0" ] ; then
            echo -e "\e[31mCouldn't found empty port\e[0m"
            continue
        fi
        echo -e "\e[32mempty port=" $port "\e[0m"
        cd /home/uninet/fail
        sed "s/listen_port/${port}/" pm.ini.template>pm.ini
        ./picture_monitor.x
        cd /home/uninet/
    else
        echo -e "\e[32mclose fail_monitor_server\e[0m"
        break
    fi
done

