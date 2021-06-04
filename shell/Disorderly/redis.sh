#!/bin/bash
echo "安装依赖"
yum -y install gcc tcl &>/dev/null
cd /data/
wget 114.251.62.161:50801/redis-4.0.9.tar.gz
wget 114.251.62.161:50801/redisd
tar xf redis-4.0.9.tar.gz
mv redis-4.0.9 redis
cd redis
make &>/dev/null
mv redis.conf redis.conf.bak
wget 114.251.62.161:50801/redis.conf
cp redis.conf 6380.conf
/data/redis/src/redis-server /data/redis/redis.conf
echo "ps -ef|grep redis  有进程表示启动成功"
cp redisd /etc/init.d/
cd /etc/init.d/
chmod +x redisd
chkconfig --add redisd
chkconfig redisd on
echo "在/etc/init.d/下执行./redisd stop关闭./redisd start开启，看进程确认是否执行成功"