#!/bin/bash
echo "安装python3，3个ok成功"
cd /usr/local/src/
yum -y install readline-devel zlib* python-devel gcc c++ libffi-devel python-devel openssl-devel psutil &>/dev/null
wget -c https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz &>/dev/null
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