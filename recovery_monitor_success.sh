#!/bin/bash
MONITOR_SUCCESS_PORTS=(50214 50224 50234 50244 50254 50264 50274 50284 50294 50204)
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
echo "1">/home/uninet/monitor_success_recovery.dat
while true ; do
    n=$(cat /home/uninet/monitor_success_recovery.dat)
    if [ $n == "1" ] ; then
        echo -e "\e[32mFind unuse port.\e[0m"
        port=$(find_empty_ports ${MONITOR_SUCCESS_PORTS[@]})
        if [ "$port" = "0" ] ; then
            echo -e "\e[31mCouldn't not found empty port\e[0m"
            continue
        fi
        echo -e "\e[32mport=" $port "\e[0m"
        cd /home/uninet/success
        sed "s/inner_port/${port}/" ms.ini.template>ms.ini
        ./monitor_success
        cd /home/uninet/
    else
        echo -e "\e[32mclose arbnr_server\e[0m"
        break
    fi
done
