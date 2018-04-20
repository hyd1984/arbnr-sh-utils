#!/bin/bash
export PORT=3306
export HOST=127.0.0.1
export USERID=eventpal
if [  -z "$1" ]
then
     echo enter raceid
     exit
fi
mysql   -s --host=${HOST} --user=${USERID} -p --port=${PORT} --execute="use eventpal_albums;select race_ocr.img_name,race_ocr.ocr_number,race_runner.UserName,race_ocr.photo_time,race_ocr.buy_photo,race_list.race_title from  race_ocr,race_runner,race_list where  race_ocr.race_id='$1' and race_runner.PlateNumber=race_ocr.ocr_number and race_ocr.race_id=race_list.race_id"
