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

mysql -s  --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;update race_runner  set ChipID='000000000000' where  PlateNumber='$1'"

mysql -s  --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;update select *  from race_nunner where  PlateNumber='$1'"
