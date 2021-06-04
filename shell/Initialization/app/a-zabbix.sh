#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|*******************zabbix*****************|
-------------------------------------------
`echo -e "\033[35m 1)zabbix_server\033[0m"`
`echo -e "\033[35m 2)zabbix_agent\033[0m"`
`echo -e "\033[35m 3)退出\033[0m"`
EEE
read -p "选择应用: " num1
case $num1 in
  1)
    echo "zabbix_server"
      qqq_menu
      ;;
  2)
     echo "zabbix_agent"
       www_menu
       ;;
   3)
     exit 0
esac
}
function qqq_menu ()
{
/usr/bin/sh ./app/a-zabbix_server.sh
}
function www_menu ()
{
/usr/bin/sh ./app/a-zabbix_agent.sh
}
menu