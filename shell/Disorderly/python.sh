#!/bin/bash
function menu ()
{
    cat << EEE
    --------------------------------------------------------
|****************主菜单(package.tar.gz)**************|
--------------------------------------------------------
`echo -e "\033[35m 1)python3+pip3\033[0m"`
`echo -e "\033[35m 2)node\033[0m"`
`echo -e "\033[35m 3)yarn\033[0m"`
`echo -e "\033[35m 4)mongo\033[0m"`
`echo -e "\033[35m 5)退出\033[0m"`
EEE
read -p "选择部署平台: " num1
case $num1 in
  1)
    echo "python3+pip"
      ppp_menu
      ;;
  2)
     echo "node安装"
       nnn_menu
       ;;
  3)
     echo "yarn安装"
      yyy_menu
      ;;
  4)
     echo "mongo安装"
      mmm_menu
      ;;
   5)
     exit 0
esac
}
function ppp_menu ()
{
echo "安装python3，3个ok成功"
cd /usr/local/src/
yum -y install readline-devel zlib* python-devel gcc c++ libffi-devel python-devel openssl-devel psutil &>/dev/null
wget 114.251.62.161:50801/Python-3.6.3.tgz &>/dev/null
tar xf Python-3.6.3.tgz
cd Python-3.6.3
./configure --prefix=/usr/local/python3 &>/dev/null
if (( $? == 0 ))
   then
     echo "ok"
    else
     echo "errors"
     exit
fi
make &>/dev/null
if (( $? == 0 ))
   then
     echo "ok"
    else
     echo "errors"
     exit
fi
make install &>/dev/null
if (( $? == 0 ))
   then
     echo "ok"
    else
     echo "errors"
     exit
fi
ln -s /usr/local/python3/bin/python3.6 /usr/bin/python3
echo "安装pip3"
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
}
function nnn_menu ()
{
echo "安装node"
cd /usr/lcoal/src/
wget https://nodejs.org/dist/v8.11.2/node-v8.11.2-linux-x64.tar.xz &>/dev/null
tar xf node-v8.11.2-linux-x64.tar.xz
mv node-v8.11.2-linux-x64 node
ln -s /usr/local/src/node/bin/node /usr/local/sbin/
ln -s /usr/local/src/node/bin/npx  /usr/local/sbin/
ln -s /usr/local/src/node/bin/npm /usr/local/sbin/
}
function yyy_menu ()
{
echo "安装yarn"
cd /usr/local/src/
mkdir yarn
cd yarn/
wget 114.251.62.161:50801/yarn-v1.12.1.tar.gz &>/dev/null
#wget https://github.com/yarnpkg/yarn/releases/download/v1.12.1/yarn-v1.12.1.tar.gz
tar xf yarn-v1.12.1.tar.gz
cd yarn-v1.12.1/
echo 'export PATH=$PATH:/var/local/src/yarn/yarn-1.12.1/bin' >>/etc/profile
source /etc/profile
ln -s /usr/local/src/yarn/yarn-v1.12.1/bin/yarn /usr/bin/yarn
yarn -v
}
function mmm_menu ()
{
echo "安装mongo"
cd /usr/local/src/
wget 114.251.62.161:50801/mongodb-linux-x86_64-rhel62-3.4.5.tgz
tar xf mongodb-linux-x86_64-rhel62-3.4.5.tgz 
mv mongodb-linux-x86_64-rhel62-3.4.5/ mongodb/
cd mongodb/
mkdir -p data/db
mkdir -p data/logs/mongodb.log
mkdir -p data/db
touch log
cat >>/usr/local/mongodb/data/mongodb.conf <<EOF
#端口号
port = 27017
#数据目录
dbpath = /usr/local/mongodb/data/db
#日志目录
logpath = /usr/local/mongodb/data/logs/mongodb.log
#设置后台运行
fork = true
#日志输出方式
logappend = true
#开启认证
#auth = true
EOF
echo 'export PATH=/usr/local/src/mongod/bin:$PATH' >>/etc/profile
source /etc/profile
cd /usr/local/src/mongodb/bin/
./mongod --dbpath=/usr/local/src/mongodb/data/ --fork --logpath=/usr/local/src/mongodb/log
ln -s /usr/local/src/mongodb/bin/mongo /usr/bin/mongo
}
menu