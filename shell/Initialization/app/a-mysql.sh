#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|*******************mysql*****************|
-------------------------------------------
`echo -e "\033[35m 1)编辑安装\033[0m"`
`echo -e "\033[35m 2)docker容器\033[0m"`
`echo -e "\033[35m 3)退出\033[0m"`
EEE
read -p "选择应用: " num1
case $num1 in
  1)
    echo "编辑安装"
      qqq_menu
      ;;
  2)
     echo "docker容器"
       www_menu
       ;;
   3)
     exit 0
esac
}
function qqq_menu ()
{
echo "Not for the time being(暂不提供)"
}
function www_menu ()
{
echo "判断是否安装docker"
Docker=`which docker`
if [ "$Docker" == 0 ]
then
  echo -e  "Please install docker"
  exit
else
  echo -e  "yes"
fi
mkdir -p /data/mysql/
cat > /data/mysql/docker-compose.yml << EOF
version: "3"
services:
  mysql:
    container_name: "mysql"
    restart: always
    volumes:
      - /data/mysql/data:/var/lib/mysql
      - /data/mysql/conf/my.cnf:/etc/my.cnf
    image: harbor02.sllhtv.com:5443/shulian/mysql:1.1.1
    environment:
      - MYSQL_ROOT_PASSWORD=123.com
      - TZ=Asia/Shanghai
    ports:
      - "3306:3306"
EOF
cd /data/mysql/
docker-compose up -d
}
menu