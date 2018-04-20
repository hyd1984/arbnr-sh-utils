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
mysql -s  --host=${HOST} --user=${USERID} --password=${PASSWORD} --port=${PORT} --execute="use eventpal_albums;update race_ocr set photo_time =date_sub(photo_time,Interval $2 second) where  race_id=$1"
