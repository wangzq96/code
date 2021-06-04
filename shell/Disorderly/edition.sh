#!/bin/bash
. /etc/init.d/functions
function menu ()
{
cat  << EOF
--------------------------------------------------------
|****************菜单(package.tar.gz)**************|
--------------------------------------------------------
`echo -e "\033[35m 1)地区所有版本号\033[0m"`
`echo -e "\033[35m 2)根据mac查询地市和版本\033[0m"`
`echo -e "\033[35m 3)根据mac查询项目\033[0m"`
`echo -e "\033[35m 4)根据版本查询mac\033[0m"`
`echo -e "\033[35m 5)退出\033[0m"`
EOF
read -p "选择序号：" num
case $num in
 1)
  echo "地区所有版本号"
  q_menu
  ;;
 2)
  echo "根据mac查询地址和版本"
  w_menu
  ;;
 3)
  echo "根据mac查询项目"
  e_menu
  ;; 
4)
 echo "根据版本查询mac"
 r_menu
 ;;  
 5)
  exit 0
esac 
}
 function q_menu ()
 {
    #地区所有版本号
    echo "输入所查询的地市：" 
    read CITY
    ID=`/usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select id,name from smart.smart_city where name='$CITY'" |awk '{print $1}'|grep -v "id"`
    /usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select province_id,mac,upgrade_version from smart.smart_device where province_id=$ID group by upgrade_version;"
 }
 function w_menu ()
 {
    #根据mac查询地市和版本
    echo "输入所查询的mac：（例：c88f26346b9d）"
    read MAC
    A=`/usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select city_id,upgrade_version from smart.smart_device where mac='$MAC';" | awk '{print $1}' | grep -v [a-z]`
    B=`/usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select city_id,upgrade_version from smart.smart_device where mac='$MAC';" | awk '{print $2}' | grep -v [a-z]`
    C=`/usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select id,name from smart.smart_city where id='$A'"`
    D=`echo $C $B |awk '{print $4.$5}'`
    echo $D
 }
 function e_menu ()
 {
   #根据mac查询项目
   echo "输入所查询的mac:（例：c88f26346b9d）"
   read MAC
   A=`/usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select project_id from smart.smart_device where mac='$MAC';"| grep -v [a-z]`
   /usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select id,name,city from smart.smart_project where id='$A';"
 }
 function r_menu ()
 {
   echo "根据版本查询mac总数"
   while read i
   do
   /usr/local/mysql/bin/mysql -u root -p"2Jo6J1obHc" -e "select upgrade_version,mac from smart.smart_device where upgrade_version='$i';" |sort |uniq|awk '{print $2}'|wc -l
   exit 0  #删除exit后可循环查询不同版本，ctrl+c结束
   done
 }
menu
#mysql -u root -p"2Jo6J1obHc" -e "select id,name from smart.smart_city where name='山东省'"
#mysql -u root -p"2Jo6J1obHc" -e "select province_id,mac,upgrade_version from smart.smart_device where province_id=15 group by upgrade_version;"
#mysql -u root -p"2Jo6J1obHc" -e "select province_id,upgrade_version,mac from smart.smart_device where upgrade_version='1.1.15.1115';" |sort |uniq