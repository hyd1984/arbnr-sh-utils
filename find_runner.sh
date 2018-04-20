#!/bin/bash
export PORT=3306
export HOST=127.0.0.1
export USERID=eventpal
if [  -z "$1" ]
then
     echo enter raceid
     exit
fi
echo "race_runner"
mysql -s  --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;select * from  race_runner where  PlateNumber='$1'"
echo "race_ocr"
mysql -s  --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;select * from  race_ocr where ocr_number='$1'"
echo "fail db"
sqlite3 /home/uninet/fail/race.db "select * from runner where Number='$1'"
