#!/bin/bash
Host_name=`cat /etc/hostname`
Version=`cat /etc/redhat-release | awk '{print $1,$2,$4}'`
Host_IP=`ip a | grep inet|grep -v 127.0.0.1|awk '{print $2}'|tr -d "addr:" | grep -E -w "^10" | awk -F '/' '{print $1}' | head -n 1`
Host_cpu=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
Host_mem=`awk '($1 == "MemTotal:"){print $2/1048576}' /proc/meminfo`
Host_selinux=`getenforce`
Host_tcp=`ulimit -a | grep "open files" | awk '{print $4}'`
Host_sshd_port=`cat /etc/ssh/sshd_config  | grep "Port [0-9]*" | awk '{print $2}'`

ping -c2 -i0.3 -W1 www.baidu.com &>/dev/null
if [ $? -eq 0 ];then
  echo -e "\033[42;31m访问外网\033[0m               :up"
else
  echo -e "\033[42;31m访问外网\033[0m               :down"
fi

ping -c2 -i0.3 -W1 112.35.63.175 &>/dev/null
if [ $? -eq 0 ];then
    echo -e "\033[42;31m访问112.35.63.175\033[0m      :up"
else
    echo -e "\033[42;31m访问112.35.63.175\033[0m      :down"
fi

echo -e "\033[42;31m系统版本\033[0m               :"$Version"" 
echo -e "\033[42;31m主机名\033[0m                 :"$Host_name"" 
echo -e "\033[42;31mIP\033[0m                     :"$Host_IP""  
echo -e "\033[42;31mCPU核数\033[0m                :"$Host_cpu"" 
echo -e "\033[42;31m内存大小\033[0m               :"$Host_mem"G" 
echo -e "\033[42;31mselinux\033[0m                :"$Host_selinux""
echo -e "\033[42;31m最大连接数\033[0m             :"$Host_tcp""
echo -e "\033[42;31mssh端口号\033[0m              :"$Host_sshd_port""

FIRE=`ps -ef |grep firewalld | grep -v grep`
if [[ "$FIRE" != *python* ]]
then
  echo -e "\033[42;31mfirewalld\033[0m              :down" 
else
  echo -e "\033[42;31mfirewalld\033[0m              :up" 
fi

Route=`cat  /proc/sys/net/ipv4/ip_forward`
if [ "$Route" == 0 ]
then
  echo -e  "\033[42;31m路由转发功能\033[0m           :down"
else
  echo -e  "\033[42;31m路由转发功能\033[0m           :up"
fi

echo -e "\033[42;31m磁盘数量and大小\033[0m" 
fdisk -l |grep "Disk /dev" | awk '{print $2,$3,$4}'

echo -e "\033[42;31m已挂载的盘\033[0m" 
df -TH | grep "/dev/" | grep -v "tmpfs" | awk '{print $1,$3,$NF}' | sed 's#/dev/##'

echo -e  "\033[42;31m现有服务\033[0m"
netstat -nltp | grep -v "tcp6" |grep -v "Active" | grep -v "Proto" | awk '{print $4"###"$NF}' | awk -F ":" '{print "port:"$2}' | sed 's#[0-9]*/##' | sort | uniq