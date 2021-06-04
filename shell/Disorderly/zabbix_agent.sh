#!/bin/bash
echo "安装zabbix需要的依赖,稍等"
yum -y install gcc gcc-c++ make net-snmp net-snmp-devel curl curl-devel libxml2 libxml2-devel >/dev/null
echo $?
echo "创建用户"
useradd -s /sbin/nologin -M zabbix >/dev/null
echo $?
echo "下载安装包"
cd /usr/loca/src/ >/dev/null
wget 114.251.62.161:50801/zabbix-3.4.1.tar.gz >/dev/null
echo $?
echo "安装zabbix"
tar xf zabbix-3.4.1.tar.gz >/dev/null
cd zabbix-3.4.1 >/dev/null
./configure --prefix=/usr/local/zabbix --enable-agent >/dev/null
echo $?
echo "编辑安装"
make && make install >/dev/null
echo $?
mkdir /var/log/zabbix >/dev/null
chown -R zabbix.zabbix /var/log/zabbix >/dev/null
cd /usr/local/zabbix/misc/ >/dev/null
echo "拷贝启动脚本"
cd /etc/init.d/ >/dev/null
wget 114.251.62.161:50801/zabbix_agentd >/dev/null
chmod +x /etc/init.d/zabbix_agentd >/dev/null
chkconfig --add zabbix_agentd
chkconfig zabbix_agentd on
chkconfig --list
cd /usr/local/zabbix/etc/
mv zabbix_agentd.conf zabbix_agentd.conf.bak
cd
A=`hostname`
cat >>/usr/local/zabbix/etc/zabbix_agentd.conf<<EOF
Server=10.170.70.17
ServerActive=10.170.70.17:10066
Hostname=gaungxi_$A
LogFile=/var/log/zabbix/zabbix_agentd.log
EnableRemoteCommands = 1
ListenPort=10065
Timeout=10
Include=/usr/local/zabbix/etc/zabbix_agentd.conf.d/*.conf
EOF
/etc/init.d/zabbix_agentd start
netstat -nltp