echo "LOCK tables race_runner write;"
awk '{printf "insert into race_runner (ChipID,PlateNumber,UserName,AppIndex,sex,CreateTime,race_id) values(\047%s\047,\047%s\047,\047%s\047,NULL,NULL,NULL,3);\n",$1,$2,$3}'
echo "unlock tables;"
