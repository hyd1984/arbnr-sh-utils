#!/bin/bash
export PORT=3306
export HOST=127.0.0.1
export USERID=eventpal
if [  -z "$1" ]
then
     echo enter raceid
     exit
fi
mysql -sN --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;delete from race_ocr where  race_id=$1;delete from h_recognition where race_id=$1"
