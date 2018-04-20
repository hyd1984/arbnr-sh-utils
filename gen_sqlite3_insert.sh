echo "PRAGMA foreign_keys=OFF;"
echo "BEGIN TRANSACTION;"
awk '{printf "insert into runner (Number,Name) values(\047%s\047,\047%s\047);\n",$1,$2}'
echo "COMMIT;"
