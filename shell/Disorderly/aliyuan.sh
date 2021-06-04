#!/bin/bash
cd /etc/yum.repos.d/
mv CentOs-Base.repo  CentOS-Base.repo.back
wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo 
yum clean all
mv CentOS-repo CentOS-Base.repo
yum makecache