#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|******************tengine****************|
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
mkdir -p /data/tengine/
#cat > /data/tengine/docker-compose.yml << EOF
#version: "3"
#services:
#  redis:
#    container_name: "redis"
#    restart: always
#    image: harbor02.sllhtv.com/shulian/redis:1.1.3
#    volumes:
#      - /data/tengine/redis.conf:/usr/local/etc/redis/redis.conf
#      - /data/tengine/data:/data
#    ports:
#      - "6379:6379"
#EOF
#cd /data/redis/
#/usr/local/bin/docker-compose up -d redis
}
menu