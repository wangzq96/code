#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|******************mongodb****************|
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
echo "下载安装包"
cd
mkdir /data/
cd /data/
wget -c https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel62-3.6.5.tgz &>/dev/null
echo "解压"
tar xf mongodb-linux-x86_64-rhel62-3.6.5.tgz
mv mongodb-linux-x86_64-rhel62-3.6.5 mongodb
mkdir -p ./mongodb/data/
mkdir -p ./mongodb/logs/
mkdir -p ./mongodb/data/db
cat > /data/mongodb/mongodb.conf << EOF
port=27017
dbpath=/data/mongodb/data/db
logpath=/var/mongodb/logs/mongodb.log
pidfilepath=/data/mongodb/mongo.pid
fork=true
logappend=true
EOF
echo "/data/mongodb/bin/mongod --config /data/mongodb/mongodb.conf" >> /etc/rc.local
echo "启动"
/data/mongodb/bin/mongod --config /data/mongodb/mongodb.conf &>/dev/null
echo "启动完毕"
chmod +x /etc/rc.local
}
function www_menu ()
{
echo "Not for the time being(暂不提供)"
}
menu