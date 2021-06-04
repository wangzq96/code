#!/bin/bash
echo "根据版本查询mac"
for i in {1.1.05.1105,1.1.06.1106}
do
/usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select upgrade_version,mac from smart.smart_device where upgrade_version='$i';" |sort |uniq|awk '{print $2}'|wc -l
done