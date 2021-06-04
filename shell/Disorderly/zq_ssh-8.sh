#!/bin/bash
echo "安装依赖"
yum install gcc zlib-devel openssl-devel pam-devel -y &>/dev/null
mv /home/sl_zq/openssh-8.0p1.tar.gz /usr/local/src/
mv /home/sl_zq/openssl-1.0.2r.tar.gz /usr/local/src/
sleep 5
cd /usr/local/src/
tar -xf  openssl-1.0.2r.tar.gz
cd /usr/local/src/openssl-1.0.2r
echo "安装ssl"
./config --prefix=/usr/local/openssl-1.0.2r &>/dev/null
echo $?
echo "编辑安装"
make &>/dev/null
echo $?
make install &>/dev/null
echo $?
rm -f /bin/openssl
ln -s /usr/local/openssl-1.0.2r/bin/openssl /bin
openssl version
sleep 5
cd /usr/local/src/
tar -xf openssh-8.0p1.tar.gz
cd /usr/local/src/openssh-8.0p1/
echo "安装ssh"
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-md5-passwords  --with-tcp-wrappers --with-ssl-dir=/usr/local/openssl-1.0.2r --without-hardening &>/dev/null
echo $?
echo "编辑ssh"
make &>/dev/null
echo $?
make install &>/dev/null
echo $?
service sshd restart
ssh -V