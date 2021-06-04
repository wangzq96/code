#!/bin/bash
echo "下载mysql安装包"
cd /usr/local/src/
wget 114.251.62.161:50801/mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz
echo "mysql 初始化安装脚本"
useradd -s /sbin/nologin -M mysql
######################定义变量######################
GROUP_NAME=mysql
USER_NAME=mysql
MYSQLDB_HOME=/usr/local/mysql
MYSQLDB_DATA_HOME=/data/mysql/
MYSQL_VERSION="mysql-5.7.21-linux-glibc2.12-x86_64"
###################################################
# 判断mysql目录是否创建
if [ -d $MYSQLDB_HOME ];then
    echo "目录已创建"
    else
    mkdir -p $MYSQLDB_HOME
fi
cd /usr/local/src/
# 判断mysql软件包是否存在
tar -zxvf $MYSQL_VERSION.tar.gz &>/dev/null
mv $MYSQL_VERSION/* $MYSQLDB_HOME/

# 安装libaio
yum -y install libaio

if [ -s /etc/my.cnf ]; then
        mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d%H%M%S`.bak
fi

echo "====================安装mysql5.7.21=========================="

# 创建mysql配置文件：
cd /usr/local/src/
wget 114.251.62.161:50801/my.cnf
mv my.cnf /etc/

# 设置mysql数据目录权限
if [ -d $MYSQLDB_DATA_HOME ];then
    echo "目录已存在"
    else
    mkdir -p $MYSQLDB_DATA_HOME
    chown -R mysql:mysql $MYSQLDB_DATA_HOME
    echo "目录和权限创建成功！"
fi

# 创建安装目录下的日志文件
mkdir -p $MYSQLDB_HOME/log
touch $MYSQLDB_HOME/log/mysql_error.log
#touch $MYSQLDB_HOME/log/mysql-slow.log
chown -R mysql:mysql $MYSQLDB_HOME

# 配置开机启动
function add_auto_start
{
   cp $MYSQLDB_HOME/support-files/mysql.server /etc/rc.d/init.d/mysqld
   chmod +x /etc/rc.d/init.d/mysqld
   chkconfig --add mysqld
   chkconfig mysqld on
}
# 初始化数据库
cd $MYSQLDB_HOME/bin/
./mysqld --initialize --user=mysql --basedir=$MYSQLDB_HOME/ --datadir=$MYSQLDB_DATA_HOME

# 设置环境变量
echo 'export PATH=$PATH:/usr/local/mysql/bin/'  >> /etc/profile
source /etc/profile
ln -s /usr/local/mysql/bin/mysql /usr/bin

echo "mysql 5.7.21 安装完成，密码文件请查看$MYSQLDB_HOME/log/mysql_error.log 文件"
sleep 5
#########################################################################################
add_auto_start
source /etc/profile
service mysqld start
ln -s /usr/local/mysql/bin/mysql /usr/bin/