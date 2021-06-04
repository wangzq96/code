#!/bin/bash

  

######################定义变量######################
GROUP_NAME=mysql
USER_NAME=mysql
MYSQLDB_HOME=/usr/local/mysql
MYSQLDB_DATA_HOME=/data/mysql/
MYSQL_VERSION="mysql-5.7.21-linux-glibc2.12-x86_64"
###################################################

if [ $(id -u) != "0" ];then
   echo "Error: You must be root to run this script!"
   exit 1
fi

echo "========================================================================="
echo " install MySQL 5.7.21 on Redhat/CentOS Linux "
echo "========================================================================="


#addGroup

if [ -z $(cat /etc/group|awk -F: '{print $1}'| grep -w "$GROUP_NAME") ]
then
  groupadd  $GROUP_NAME
    if(( $? == 0 ))
      then
         echo "group $GROUP_NAME add sucessfully!"
    fi
else
  echo "$GROUP_NAME is exsits"
fi

#addUser

if [ -z $(cat /etc/passwd|awk -F: '{print $1}'| grep -w "$USE_NAME") ]
then
  adduser -g $GROUP_NAME $USER_NAME
     if (( $? == 0 ))
       then
       echo "user $USER_NAME add sucessfully!"
     fi
else
  echo "$USER_NAME is exsits"
fi



# 判断mysql目录是否创建
if [ -d $MYSQLDB_HOME ];then
    echo "目录已创建"
    else
    mkdir -p $MYSQLDB_HOME
fi



# 判断mysql软件包是否存在
if [ -f ${MYSQL_VERSION}.tar.gz ]
then
tar -zxvf $MYSQL_VERSION.tar.gz
mv $MYSQL_VERSION/* $MYSQLDB_HOME/
else
echo "没有发现mysql二进制文件"
echo "请将mysql二进制文件放到和本脚本在同一目录中"
exit 2
fi

# 安装libaio
yum -y install libaio 
yum -y install numactl
if [ -s /etc/my.cnf ]; then
        mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d%H%M%S`.bak
fi

echo "====================安装mysql5.7.21=========================="

# 创建mysql配置文件：
cat >>/etc/my.cnf<<EOF

[mysql]

# 设置mysql客户端默认字符集

default-character-set=utf8

socket=/tmp/mysql.sock

[mysqld]

#skip-name-resolve

#设置3307端口

port = 3307


# 设置mysql的安装目录

basedir=/usr/local/mysql

# 设置mysql数据库的数据的存放目录

datadir=/data/mysql


# 服务端使用的字符集默认为8比特编码的latin1字符集

character-set-server=utf8

# 创建新表时将使用的默认存储引擎

default-storage-engine=INNODB

#lower_case_table_name=1

max_allowed_packet=16M

key_buffer_size=32MB

# innodb参数
#
innodb_buffer_pool_size=512MB

innodb_buffer_pool_dump_at_shutdown=1  #该命令用于在关闭时把热数据dump到本地磁盘
innodb_buffer_pool_load_at_startup=1   #在启动时把热数据加载到内存

#避免双写缓冲的参数：
innodb_flush_method=O_DIRECT

innodb_lock_wait_timeout=50 # 锁等待超时时间 单位秒
#启用标准InnoDB监视器
innodb_status_output=ON
# 查询缓存
#开启慢查询日志：
slow_query_log=1
slow_query_log_file=master.slow
long_query_time=2
#配置错误日志：
log-error=/usr/local/mysql/log/mysql_error.log
# 复制的参数
log_bin=master-bin
server_id=10
binlog_format=ROW
sync_binlog=1
# 半同步复制参数
#rpl_semi_sync_master_enabled = 1
#rpl_semi_sync_master_timeout = 1000 # 单位秒

#sql-mode=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
#sql-mode=ONLY_FULL_GROUP_BY,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
sql_mode=NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION

# 启用gtid复制：
gtid_mode=ON
enforce-gtid-consistency=true
max_connections = 1000
max_connect_errors = 1000
wait_timeout = 30

EOF

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
}


# 初始化数据库
cd $MYSQLDB_HOME/bin/
./mysqld --initialize --user=mysql --basedir=$MYSQLDB_HOME/ --datadir=$MYSQLDB_DATA_HOME


# 设置环境变量

echo 'export PATH=$PATH:/usr/local/mysql/bin/'  >> /etc/profile

source /etc/profile

echo "mysql 5.7.21 安装完成，密码文件请查看$MYSQLDB_HOME/log/mysql_error.log 文件"
sleep 5
#########################################################################################
add_auto_start