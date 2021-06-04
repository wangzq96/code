#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|********************应用******************|
-------------------------------------------
`echo -e "\033[35m 1)yum\033[0m"`
`echo -e "\033[35m 2)docker\033[0m"`
`echo -e "\033[35m 3)tengine\033[0m"`
`echo -e "\033[35m 4)redis\033[0m"`
`echo -e "\033[35m 5)mysql\033[0m"`
`echo -e "\033[35m 6)kafka+zookeeper\033[0m"`
`echo -e "\033[35m 7)mongodb\033[0m"`
`echo -e "\033[35m 8)vsftpd\033[0m"`
`echo -e "\033[35m 9)python3\033[0m"`
`echo -e "\033[35m 10)openvpn-agent\033[0m"`
`echo -e "\033[35m 11)zabbix\033[0m"`
`echo -e "\033[35m 12)退出\033[0m"`
EEE
read -p "选择应用: " num1
case $num1 in
  1)
    echo "yum"
      qqq_menu
      ;;
  2)
     echo "docker"
       www_menu
       ;;
  3)
     echo "nginx"
      eee_menu
      ;;
  4)
     echo "redis"
      rrr_menu
      ;;
  5)
     echo "mysql"
      ttt_menu
      ;;
  6)
     echo "kafka+zookeeper"
      yyy_menu
      ;;
  7)
     echo "mongodb"
      uuu_menu
      ;;
  8)
     echo "vsftpd"
      iii_menu
      ;;
  9)
     echo "python3"
      ooo_menu
      ;;
  10)
     echo "openvpn-agent"
      ppp_menu
      ;;
  11)
     echo "zabbix"
      aaa_menu
      ;;
  12)
     exit 0
esac
}
function qqq_menu ()
{
/usr/bin/sh ./app/a-yum.sh
}
function www_menu ()
{
/usr/bin/sh ./app/a-docker.sh
}
function eee_menu ()
{
/usr/bin/sh ./app/a-tengine.sh
}
function rrr_menu ()
{
/usr/bin/sh ./app/a-redis.sh
}
function ttt_menu ()
{
/usr/bin/sh ./app/a-mysql.sh
}
function yyy_menu ()
{
echo "kafka+zookeeper"
}
function uuu_menu ()
{
/usr/bin/sh ./app/a-mongodb.sh
}
function iii_menu ()
{
/usr/bin/sh ./app/a-vsftp.sh
}
function ooo_menu ()
{
/usr/bin/sh ./app/a-python3.sh
}
function ppp_menu ()
{
/usr/bin/sh ./app/a-openvpn-agent.sh
}
function aaa_menu ()
{
/usr/bin/sh ./app/a-zabbix.sh
}
menu