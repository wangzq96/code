#!/bin/bash
Y=`ifconfig |awk 'NR==2'|awk '{print $2}'`
echo 本机IP是:$Y
Q=`hostname`
echo 主机名:$Q
W=`cat /proc/cpuinfo | grep "physical id" |  uniq | wc -l`
echo 服务器CPU:$W
E=`cat  /etc/redhat-release |awk '{print $1}'`
R=`cat  /etc/redhat-release |awk '{print $3}'`
echo 服务器版本是:$E $R
T=`free -h |awk 'NR==2' |awk '{print $2}'`
echo 服务器总内存:$T
Y=`fdisk -l |grep Disk |cut -c6-30 | grep GB |awk -F ',' '{print $1}'`
echo 服务器磁盘大小:$Y
