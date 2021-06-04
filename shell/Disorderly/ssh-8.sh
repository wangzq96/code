#!/bin/bash
my_time=`date +%Y%m%d`
my_a=/data/tools/
mkdir -p ./ssh-bak/
my_b="$my_a"/ssh-bak/
cd "$my_a"
echo "安装依赖"
yum install  -y gcc gcc-c++ glibc make autoconf openssl openssl-devel pcre-devel  pam-devel pam* zlib*  &>/dev/null
echo $?
echo "下载ssl和ssh包"
wget https://openbsd.hk/pub/OpenBSD/OpenSSH/portable/openssh-8.0p1.tar.gz  &>/dev/null
echo $?
wget https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2r.tar.gz  &>/dev/null
echo $?
echo "继续安装"
mv /usr/bin/openssl /usr/bin/openssl_"$my_time"
mv /usr/include/openssl /usr/include/openssl_"$my_time"
tar xf openssl-1.0.2r.tar.gz
cd ./openssl-1.0.2r/
echo "编辑安装openssl"
./config shared  &>/dev/null
echo $?
echo "make-ssl"
make &>/dev/null
echo $?
echo "make--install--ssl"
make install  &>/dev/null
echo $?
echo "3"
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
ll /usr/bin/openssl
ll /usr/include/openssl -ld
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
/sbin/ldconfig
openssl version
cd "$my_a"
tar xf openssh-8.0p1.tar.gz 
cd  ./openssh-8.0p1
chown -R root.root `pwd`
cd "$my_b"
mv /etc/ssh/* ./
cd ../openssh-8.0p1
echo "安装编辑openssh"
./configure --prefix=/usr/ --sysconfdir=/etc/ssh  --with-openssl-includes=/usr/local/ssl/include --with-ssl-dir=/usr/local/ssl   --with-zlib   --with-md5-passwords   --with-pam &>/dev/null
echo $?
echo "make--ssh"
make &>/dev/null
echo $?
echo "make--install--ssh"
make install &>/dev/null
echo $?
echo "6"
echo 'PermitRootLogin yes' >>/etc/ssh/sshd_config
echo 'UseDNS no' >>/etc/ssh/sshd_config
mv /etc/init.d/sshd /etc/init.d/sshd-"$my_time"
cp -a contrib/redhat/sshd.init /etc/init.d/sshd
mv  /etc/pam.d/sshd.pam /etc/pam.d/sshd.pam-"my_time"
cp -a contrib/redhat/sshd.pam /etc/pam.d/sshd.pam
chmod +x /etc/init.d/sshd
chkconfig --add sshd
systemctl enable sshd
mv  /usr/lib/systemd/system/sshd.service  "$my_a"
chkconfig sshd on
systemctl stop sshd
systemctl start sshd
systemctl restart sshd
ssh -V