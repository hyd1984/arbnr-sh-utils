#!/bin/bash
export PORT=3306
export HOST=127.0.0.1
export USERID=eventpal
export PASSWORD=asdf4rfv
if [  -z "$1" ]
then
     echo enter raceid
     exit
fi
mysql -s  --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;select * from  race_number where  PlateNumber='$1'">>race_runner.sh

mysql -s  --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;update race_runner  set ChipID='058000214657' where  PlateNumber='$1'"
