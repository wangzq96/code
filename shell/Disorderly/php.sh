#!/bin/bash
echo "开始安装PHP依赖包........"
useradd -s /sbin/nologin -M www
useradd -s /sbin/nologin -M php-fpm
yum -y install epel-release perl expat-devel gcc gcc-c++ make zlib zlib-devel pcre pcre-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers php-mcrypt libmcrypt libmcrypt-devel &>/dev/null
  if [ "$?" -eq 0 ];then
    action "成功安装PHP依赖包!" /bin/true
    else
    action "PHP依赖包安装失败!" /bin/false
    exit 1
  fi
cd /usr/local/src/php/ && {
  echo  "开始安装PHP,过程稍微有点长........"
  tar -zxvf php-5.6.35.tar.gz &>/dev/null
  cd /usr/local/src/php-5.6.35
   ./configure --prefix=/usr/local/php56 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-config-file-path=/usr/local/php56/etc --disable-ipv6 --with-ftp --with-soap --with-mcrypt --with-libxml-dir --with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-gettext --enable-mbstring --with-mysql --with-mysqli --enable-embedded-mysqli --with-pdo-mysql --with-pcre-dir --enable-mysqlnd --enable-soap --enable-ftp --enable-opcache --disable-fileinfo --enable-exif --enable-sockets --with-bz2 --enable-zip --disable-fileinfo &>/dev/null
   echo "编辑，时间有点长耐心等待"
  make &>/dev/null
  echo "安装，耐心等待"
  make install &>/dev/null
  cp php.ini-production /usr/local/php56/etc/php.ini
  cd /usr/local/php56/etc
  cp php-fpm.conf.default php-fpm.conf
}
if [ "$?" -eq 0 ];then
  action "PHP安装成功!" /bin/true
  else
  action "PHP安装失败,请检查环境..." /bin/false
  exit 1
fi
cd /usr/local/php56/etc/
mv php-fpm.conf php-fpm.conf.bak
mv /usr/local/src/php/php-fpm.conf /usr/local/php56/etc/
cd /etc/init.d/
mv /usr/local/src/php/php-fpm /etc/init.d/
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on