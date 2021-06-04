#!/bin/bash
#shell菜单
. /etc/init.d/functions
function menu ()
{
     cat  << EOF
--------------------------------------------------------
|****************安装主页(package.tar.gz)**************|
--------------------------------------------------------
`echo -e "\033[35m 1)口令锁定策略\033[0m"`
`echo -e "\033[35m 2)口令生存期\033[0m"`
`echo -e "\033[35m 3)设置账号组\033[0m"`
`echo -e "\033[35m 4)避免账号共享\033[0m"`
`echo -e "\033[35m 5)配置用户最小授权\033[0m"`
`echo -e "\033[35m 6)设置关键文件的属性\033[0m"`
`echo -e "\033[35m 7)启用远程日志功能"`
`echo -e "\033[35m 8)记录安全事件日志\033[0m"`
`echo -e "\033[35m 9)日志文件安全\033[0m"`
`echo -e "\033[35m 10)限制root用户SSH远程登录\033[0m"`
`echo -e "\033[35m 11)禁止存在心血漏洞\033[0m"`
`echo -e "\033[35m 12)系统core dump状态\033[0m"`
`echo -e "\033[35m 13)控制远程访问的IP地址\033[0m"`
`echo -e "\033[35m 14)配置NTP\033[0m"`
`echo -e "\033[35m 15)禁止ICMP重定向\033[0m"`
`echo -e "\033[35m 16)设置屏幕锁定\033[0m"`
`echo -e "\033[35m 17)使用PAM认证模块禁止wheel组之外的用户su为root\033[0m"`
`echo -e "\033[35m 18)禁止IP源路由\033[0m"`
`echo -e "\033[35m 19)更改主机解析地址的顺序\033[0m"`
`echo -e "\033[35m 20)历史命令设置\033[0m"`
`echo -e "\033[35m 21)对root为ls、rm设置别名\033[0m"`
`echo -e "\033[35m 22)全部修复\033[0m"`
`echo -e "\033[35m 23)退出\033[0m"`
EOF
read -p "需要修复：" num
case $num in
 1)
  echo "口令锁定策略"
  q_menu
  ;;
 2)
  echo "口令生存期"
  w_menu
  ;;
 3)
  echo "设置账号组"
  e_menu
  ;;
 4)
  echo "避免账号共享"
  r_menu
  ;;
 5)
  echo "配置用户最小授权"
  t_menu
  ;;
 6)
  echo "设置关键文件的属性"
  y_menu
  ;;
 7)
  echo "启用远程日志功能"
  u_menu
  ;;
 8)
  echo "记录安全事件日志"
  i_menu
  ;;
 9)
  echo "日志文件安全"
  o_menu
  ;;
 10)
  echo "限制root用户SSH远程登录"
  p_menu
  ;;
 11)
  echo "禁止存在心血漏洞"
  a_menu
  ;;
 12)
  echo "系统core dump状态"
  s_menu
  ;;
 13)
  echo "控制远程访问的IP地址"
  d_menu
  ;;
 14)
  echo "配置NTP"
  f_menu
  ;;
 15)
  echo "禁止ICMP重定向"
  g_menu
  ;;
 16)
  echo "设置屏幕锁定"
  h_menu
  ;;
 17)
  echo "使用PAM认证模块禁止wheel组之外的用户su为root"
  j_menu
  ;;
 18)
  echo "禁止IP源路由"
  k_menu
  ;;
 19)
  echo "更改主机解析地址的顺序"
  l_menu
  ;;
 20)
  echo "历史命令设置"
  z_menu
  ;;
 21)
  echo "对root为ls、rm设置别名"
  x_menu
  ;;
 22)
  echo "全部修复"
  q_menu
  w_menu
  e_menu
  t_menu
  y_menu
  u_menu
  i_menu
  o_menu
  p_menu
  a_menu
  s_menu
  d_menu
  f_menu
  g_menu
  h_menu
  j_menu
  k_menu
  l_menu
  z_menu
  x_menu
  ;;
 23)
  exit 0
esac 
}
 function y_menu ()
 {
chattr +a /var/log/messages
lsattr /var/log/messages
}
 function h_menu ()
 {
yum -y install gconf-editor &>/dev/null
gconftool-2 --direct  --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory  --type bool  --set /apps/gnome-screensaver/idle_activation_enabled true
gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory  --type bool  --set /apps/gnome-screensaver/lock_enabled true
gconftool-2 --direct   --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory    --type string   --set /apps/gnome-screensaver/mode blank-only
gconftool-2 --direct  --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory   --type int   --set /apps/gnome-screensaver/idle_delay 15
echo "idle_activation_enabled="`gconftool-2 -g /apps/gnome-screensaver/idle_activation_enabled`
echo "lock_enabled="`gconftool-2 -g /apps/gnome-screensaver/lock_enabled`
echo "mode="`gconftool-2 -g /apps/gnome-screensaver/mode`
echo "idle_delay="`gconftool-2 -g /apps/gnome-screensaver/idle_delay`
}
 function q_menu ()
 {
 cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
 echo 'auth required pam_tally2.so deny=5 onerr=fail no_magic_root unlock_time=180' >>/etc/pam.d/system-auth
 echo 'account  required  pam_tally2.so' >>/etc/pam.d/system-auth
}
 function w_menu ()
 {
 cp -p /etc/login.defs /etc/login.defs_bak
 find "/etc/login.defs"|xargs perl -pi -e 's|PASS_MAX_DAYS.*|PASS_MAX_DAYS 90|g'
 find "/etc/login.defs"|xargs perl -pi -e 's|PASS_MIN_DAYS.*|PASS_MIN_DAYS 10|g'
 find "/etc/login.defs"|xargs perl -pi -e 's|PASS_WARN_AGE.*|PASS_WARN_AGE 7|g'
 cat /etc/login.defs |grep -v "^[[:space:]]*#"|grep -E '^\s*PASS_MAX_DAYS|^\s*PASS_MIN_DAYS|^\s*PASS_WARN_AGE'
}
 function e_menu ()
 {
 cp -p /etc/group /etc/group_bak
 groupadd sl
 USER_COUNT=`cat /etc/passwd | grep '^sl_zq:' -c`
 USER_NAME='sl_zq'
 if [ $USER_COUNT -ne 1 ]
 then
 useradd $USER_NAME
 echo "qqaaZZ123@" | passwd $USER_NAME --stdin
 else
 echo 'user exits'
 fi
 usermod -g sl sl_zq
 echo "sl_zq  ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers
}
 function r_menu ()
 {
 USER_COUNT=`cat /etc/passwd | grep '^sl_zq:' -c`
 USER_NAME='sl_zq'
 if [ $USER_COUNT -ne 1 ]
 then
 useradd $USER_NAME
 echo "qqaaZZ123@" | passwd $USER_NAME --stdin
 else
 echo 'user exits'
 fi
 echo "sl_zq  ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers
}
 function t_menu ()
 {
 chmod 644 /etc/passwd
 chmod 400 /etc/shadow
 chmod 644 /etc/group
 chmod 644 /etc/services
 chmod 600 /etc/security
 chmod 600 /etc/xinetd.conf
}
 function u_menu ()
 {
 echo "*.*         @192.168.10.49" >>/etc/rsyslog.conf
 systemctl restart rsyslog.service
 cat /etc/rsyslog.conf | grep -v "^[[:space:]]*#" | grep -E '[[:space:]]*.+@.+'
}
 function i_menu ()
 {
 touch /var/adm/messages
 echo "*.err;kern.debug;daemon.notice /var/adm/messages" >>/etc/rsyslog.conf
 chmod 666 /var/adm/messages
 systemctl restart rsyslog.service
}
 function o_menu ()
 {
 chmod 640 /etc/rsyslog.d/21-cloudinit.conf
 chmod 640 /etc/rsyslog.d/listen.conf
 chmod 640 /var/log/authpriv.log
 chmod 640 /var/log/boot.log
 chmod 640 /var/log/cron
 chmod 640 /var/log/errors.log
 chmod 640 /var/log/kern.log
 chmod 640 /var/lib/rsyslog/imjournal.state
}
 function p_menu ()
 {
 cp -p /etc/group /etc/group_bak
 groupadd sl
 USER_COUNT=`cat /etc/passwd | grep '^sl_zq:' -c`
 USER_NAME='sl_zq'
 if [ $USER_COUNT -ne 1 ]
 then
 useradd $USER_NAME
 echo "qqaaZZ123@" | passwd $USER_NAME --stdin
 else
 echo 'user exits'
 fi
 usermod -g sl sl_zq
 cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bak
 find "/etc/ssh/sshd_config"|xargs perl -pi -e 's|PermitRootLogin.*|PermitRootLogin no|g'
 systemctl restart sshd
 echo "sl_zq  ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers
 find "/etc/ssh/sshd_config"|xargs perl -pi -e 's|#Protocol 2|Protocol 2|g'
}
 function a_menu ()
 {
 yum -y install openssl &>/dev/null
 openssl version
}
 function k_menu ()
 {
 for f in /proc/sys/net/ipv4/conf/*/accept_source_route
    do
       echo 0 > $f
    done
 cat /proc/sys/net/ipv4/conf/*/accept_source_route
}
 function s_menu ()
 {
 echo "* soft core 0" >>/etc/security/limits.conf
 echo "* hard core 0" >>/etc/security/limits.conf
 cat /etc/security/limits.conf|grep -v "[[:space:]]*#"
}
 function d_menu ()
 {
 cp -p /etc/hosts.allow /etc/hosts.allow_bak
 cp -p /etc/hosts.deny /etc/hosts.deny_bak
 echo "sshd:192.168.10.51:allow" >>/etc/hosts.allow
 echo "sshd:ALL" >>/etc/hosts.deny	
 cat /etc/hosts.allow |sed '/^#/d'|sed '/^$/d'|egrep -i "sshd|telnet|all"
 cat /etc/hosts.deny |sed '/^#/d'|sed '/^$/d'|egrep -i "all:all"
 echo "allowno="`egrep -i "sshd|telnet|all" /etc/hosts.allow |sed '/^#/d'|sed '/^$/d'|wc -l`
 echo "denyno="`egrep -i "sshd|telnet|all" /etc/hosts.deny |sed '/^#/d'|sed '/^$/d'|wc -l`
}
 function f_menu ()
 {
 yum -y install ntp
 systemctl enable ntpd
 systemctl restart ntpd
 ntpq -p
}
 function g_menu ()
 {
 cp -p /etc/sysctl.conf /etc/sysctl.conf_bak
 echo "net.ipv4.conf.all.accept_redirects=0" >>/etc/sysctl.conf
 sysctl  -p
}
 function j_menu ()
 {
 echo "auth            required        pam_wheel.so use_uid" >>/etc/pam.d/su
 cat /etc/pam.d/su|grep -v "^[[:space:]]*#"|grep -v "^$"|grep "^auth"
}
 function l_menu ()
 {
 echo "nospoof on" >>/etc/host.conf
 echo "order hosts,bind" >>/etc/host.conf
 cat /etc/host.conf|grep -v "^[[:space:]]*#"|egrep "order[[:space:]]hosts,bind|multi[[:space:]]on|nospoof[[:space:]]on"
}
 function z_menu ()
 {
 find "/etc/profile"|xargs perl -pi -e 's|HISTSIZE=1000|HISTSIZE=5|g'
 sed -i '/HISTSIZE=5/a\HISTFILESIZE=5' /etc/profile
 cat /etc/profile|grep -v "^[[:space:]]*#"|grep "HISTFILESIZE"
 cat /etc/profile|grep -v "^[[:space:]]*#"|grep "HISTSIZE"
}
 function x_menu ()
 {
 echo "alias ls='ls -aol'" >>~/.bashrc
 echo "alias rm='rm -i'" >>~/.bashrc
 cat /root/.cshrc|grep -v "^[[:space:]]*#"
}
menu