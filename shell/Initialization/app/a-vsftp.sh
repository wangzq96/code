#!/bin/bash
echo "采取的是yum安装"
function menu ()
{
    cat << EEE
-------------------------------------------
|******************Pattern****************|
-------------------------------------------
`echo -e "\033[35m 1)passive(被动)\033[0m"`
`echo -e "\033[35m 2)active(主动)\033[0m"`
`echo -e "\033[35m 3)exit(退出)\033[0m"`
EEE
read -p "选择应用: " num1
case $num1 in
  1)
    echo "被动"
      qqq_menu
      ;;
  2)
     echo "主动"
       www_menu
       ;;
   3)
     exit 0
esac
}
function qqq_menu ()
{
    echo "被动61001-62000端口"
yum -y install vsftpd &>/dev/null
#64位pam认证
cat > /etc/pam.d/vsftpd << EOF
#%PAM-1.0
#session    optional     pam_keyinit.so    force revoke
#auth       required    pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
#auth       required    pam_shells.so
#auth       include     password-auth
#account    include     password-auth
#session    required     pam_loginuid.so
#session    include     password-auth
auth    sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_ftp
account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_ftp
EOF
#虚拟用户名和密码
cat > /etc/vsftpd/vuser_ftp.txt << QQQ
digitlink
digitlink@123
QQQ
cat > /etc/vsftpd/chroot_list << FFF
digitlink
FFF
#被动模式配置文件
cat > /etc/vsftpd/vsftpdconf << WWW
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
ascii_upload_enable=YES
ascii_download_enable=YES
chroot_list_enable=YES
listen=YES

guest_enable=YES
guest_username=ftp
listen_port=50021

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
user_config_dir=/etc/vsftpd/vuser_conf
virtual_use_local_privs=YES
pasv_enable=YES
pasv_min_port=61001
pasv_max_port=62000
allow_writeable_chroot=YES
WWW
cd /etc/vsftpd
#生成db文件，每添加一次生成一次db文件
db_load -T -t hash -f vuser_ftp.txt vuser_ftp.db
mkdir vuser_conf
cat > ./vuser_conf/digitlink << EEE
local_root=/data/ftp/digitlink
chroot_list_enable=YES
write_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EEE
#创建用户目录
mkdir -p /data/ftp/digitlink
chmod 777 /data/
chmod 777 /data/ftp
cd /data/
chown -R ftp.root ftp/
systemctl restart vsftpd.service  && systemctl enable vsftpd.service 
}
function www_menu ()
{
yum -y install vsftpd &>/dev/null
#64位pam认证
cat > /etc/pam.d/vsftpd << EOF
#%PAM-1.0
#session    optional     pam_keyinit.so    force revoke
#auth       required    pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
#auth       required    pam_shells.so
#auth       include     password-auth
#account    include     password-auth
#session    required     pam_loginuid.so
#session    include     password-auth
auth    sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_ftp
account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_ftp
EOF
#虚拟用户名和密码
cat > /etc/vsftpd/vuser_ftp.txt << QQQ
digitlink
digitlink@123
QQQ
cat > /etc/vsftpd/chroot_list << FFF
digitlink
FFF
#被动模式配置文件
cat > /etc/vsftpd/vsftpdconf << WWW
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
ascii_upload_enable=YES
ascii_download_enable=YES
chroot_list_enable=YES
listen=YES

guest_enable=YES
guest_username=ftp
listen_port=21

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
user_config_dir=/etc/vsftpd/vuser_conf
virtual_use_local_privs=YES
pasv_enable=NO
WWW
cd /etc/vsftpd
#生成db文件，每添加一次生成一次db文件
db_load -T -t hash -f vuser_ftp.txt vuser_ftp.db
mkdir vuser_conf
cat > ./vuser_conf/digitlink << EEE
local_root=/data/ftp/digitlink
chroot_list_enable=YES
write_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EEE
#创建用户目录
mkdir -p /data/ftp/digitlink
chmod 777 /data/
chmod 777 /data/ftp
cd /data/
chown -R ftp.root ftp/
systemctl restart vsftpd.service  && systemctl enable vsftpd.service 
}
menu