#!/bin/bash
echo "适用于centos7系统安装docker-ce"
echo "卸载旧版本docker"
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine &>/dev/null
#删除现有的Docker存储库/etc/yum.repos.d/
#rm -i /etc/yum.repos.d/docker*.repo
#环境变量
#echo 'export DOCKERURL="<https://hub.docker.com/my-content>"' >> /etc/profile
#centos安装官方网址https://docs.docker.com/install/linux/docker-ce/centos/
echo "安装依赖包"
yum install -y yum-utils device-mapper-persistent-data lvm2 &>/dev/null
echo "添加Docker软件包源"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>/dev/null
echo "安装Docker CE"
yum install docker-ce docker-ce-cli containerd.io -y &>/dev/null
echo "配置镜像加速器"
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
echo "启动Docker服务并设置开机启动"
systemctl start docker
systemctl enable docker
