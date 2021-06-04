#!/bin/bash
IP=$( ip a | grep inet|grep -v 127.0.0.1|awk '{print $2}'|tr -d "addr:" | grep -E -w "10" | awk -F '/' '{print $1}' | head -n 1 )

cat > /etc/profile.d/mtime.sh << EOF
HISTSIZE=99999999
HISTFILESIZE=500000000
HISTTIMEFORMAT="%Y/%m/%d_%H:%M:%S `whoami` :"
export TMOUT=18000
export MTIME_PROFILES_ACTIVE=mtime-prd
export MTIME_SERVER_IP="${IP}"
######  echo  #####
echo -e "\e[01;33m** 你目前登录的账户是: \e[01;31m\`whoami\`\e[00m  ** \e[00m"
echo -e "\e[01;33m** 服务器地址： \e[01;31m\${MTIME_SERVER_IP}\e[00m  ** \e[00m"
#echo -e "\e[01;33m** MTIME_PROFILES_ACTIVE 的变量是： \e[01;31m\${MTIME_PROFILES_ACTIVE}\e[00m ** \e[00m"
##################
EOF
chmod +x /etc/profile.d/mtime.sh

sed -i 's#\(PASS_MIN_LEN\)./*5#PASS_MIN_LEN   8#g' /etc/login.defs
sed -i 's#\(PASS_MAX_DAYS\)./*99999#PASS_MAX_DAYS    90#g' /etc/login.defs

touch /etc/sshbanner
chown bin:bin /etc/sshbanner
chmod 644 /etc/sshbanner
echo "##############################################################"   >/etc/sshbanner
sed -i 's#\#Banner none#Banner /etc/sshbanner#g' /etc/ssh/sshd_config
systemctl restart sshd

cp -p /etc/passwd /etc/passwd_bak
cp -p /etc/shadow /etc/shadow_bak
cp -p /etc/group /etc/group_bak
chmod 0644 /etc/passwd
chmod 0400 /etc/shadow
chmod 0644 /etc/group

cp -p /etc/profile /etc/profile_bak
cp -p /etc/csh.cshrc /etc/csh.cshrc_bak
echo 'TMOUT=180' >> /etc/profile
echo 'export TMOUT' >> /etc/profile
echo 'set autologout=30' >> /etc/csh.cshrc

cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
touch /etc/security/opasswd && chown root:root /etc/security/opasswd && chmod 600 /etc/security/opasswd
sed -i 's#password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok#password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 md5#g' /etc/pam.d/system-auth

echo '##############################################################' > /etc/motd

sed -i 's#umask 022#umask 027#' /etc/profile && sed -i 's#umask 022#umask 027#' /etc/csh.cshrc && sed -i 's#umask 022#umask 027#' /etc/bashrc

echo "######################"
echo "shulian.repo"
echo "######################"
mkdir -p /etc/yum.repos.d/bak
cd /etc/yum.repos.d/
mv CentOS-* ./bak
mv epel-* ./bak
cat > /etc/yum.repos.d/shulian.repo << EOF
[shulian]
name=shulian
baseurl=http://repo01.ops01.sllhtv.com:50080/Centos76
gpgcheck=0
enabled=1
keepcache=0

[shulian-extra]
name=shulian-extra
baseurl=http://repo01.ops01.sllhtv.com:50080/extra
gpgcheck=0
enabled=1
keepcache=0
EOF
cd
#yum repolist &>/dev/null

echo "close Software"
echo "######################"
systemctl stop firewalld
systemctl stop iptables
systemctl stop NetworkManager
systemctl stop postfix
systemctl disable firewalld
systemctl disable iptables
systemctl disable NetworkManager
systemctl disable postfix

echo "close selinux"
echo "######################"
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

echo "limits.conf"
echo "######################"
cat /etc/security/limits.conf >> /etc/security/limits.conf-bak
echo "* soft nproc  65536" > /etc/security/limits.conf
echo "* hard nproc  65536" >> /etc/security/limits.conf
echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf

echo "sysctl.conf"
echo "######################"
cat >/etc/sysctl.conf<<EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.conf.all.arp_notify = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 4096 65000
net.ipv4.tcp_max_tw_buckets = 20000
net.ipv4.tcp_max_syn_backlog = 4096
net.core.netdev_max_backlog = 10240
net.core.somaxconn = 2048
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_max_orphans = 3276800
#below for docker
vm.max_map_count=262144
kernel.pid_max=262144
EOF
sysctl -p | wc -l

echo "ntp"
echo "######################"
echo "* */12 * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1" >/var/spool/cron/root

echo "ssh-DNS"
echo "######################"
sed -i 's#\#UseDNS no#UseDNS no #g' /etc/ssh/sshd_config

echo "shulian"
echo "######################"
useradd shulian
echo "SJ4L&beg10cGC" | passwd --stdin shulian &> /dev/null
echo "shulian用户创建完成，默认密码是：SJ4L&beg10cGC"
echo "shulian  ALL=(ALL)    NOPASSWD: ALL" >> /etc/sudoers