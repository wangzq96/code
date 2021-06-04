#!/bin/bash
echo "创建nginx用户"
useradd -s /sbin/nologin -M nginx
echo "安装依赖"
yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel &>/dev/null
echo "解压nginx安装包"
cd /usr/local/src/nginx/
tar -zxvf nginx-1.12.1.tar.gz &>/dev/null
cd /usr/local/src/nginx/nginx-1.12.1/
echo "进行配置"
./configure --prefix=/usr/local/nginx --with-http_dav_module   --with-http_stub_status_module --with-http_addition_module --with-http_sub_module --with-http_flv_module --with-http_mp4_module --with-http_ssl_module --with-http_gzip_static_module --user=nginx --group=nginx &>/dev/null
echo "进行编辑"
make &>/dev/null
echo "进行安装"
make install &>/dev/null
if  [ -f /usr/local/nginx/sbin/nginx ];then
        ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/
fi
if  [ "$?" -eq 0 ];then
     action "成功安装nginx!" /bin/true && /usr/local/nginx/sbin/nginx
     else
     action "安装nginx失败!" /bin/false
     exit 1
fi
cd /usr/local/nginx
mkdir logs
cd /usr/local/nginx/conf/
mv  nginx.conf nginx.conf.bak
mv /usr/local/src/nginx/nginx.conf /usr/local/nginx/conf/
cd /etc/init.d/
mv /usr/local/src/nginx/nginx /etc/init.d/
cd /etc/init.d/
chkconfig --add nginx
chkconfig nginx on
cd
#创建日志目录
mkdir -p /data/nginxlogs/as_local_access
mkdir -p /data/ngcache
#启动nginx
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf