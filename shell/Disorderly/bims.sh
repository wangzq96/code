#!/bin/bash
echo "bims平台"
echo "依赖软件tomcat、jdk、mysql、nginx（可选）"
function menu ()
{
    cat  << EOF
--------------------------------------------------------
|****************bims(package.tar.gz)**************|
--------------------------------------------------------
`echo -e "\033[35m 1)nginx安装\033[0m"`
`echo -e "\033[35m 2)jdk安装\033[0m"`
`echo -e "\033[35m 3)mysql安装\033[0m"`
`echo -e "\033[35m 4)tomcat\033[0m"`
`echo -e "\033[35m 5)退出\033[0m"`
EOF
read -p "选择部署平台: " num1
case $num1 in
  1)
    echo "nginx安装"
      nginx_menu
      ;;
  2)
    echo "jdk安装"
       jdk_menu
       ;;
  3)
    echo "mysql安装"
       mysql_menu
       ;;
  4)
    echo "tomcat"
       tomcat_menu
       ;;
  5)
     exit 0
esac
}
function nginx_menu ()
{
    echo "nginx安装"
    cd /usr/local/src/
    ./nginx.sh
}
function jdk_menu ()
{
    echo "jdk安装"
    cd /usr/local/src/
    ./jdk.sh
}
function mysql_menu ()
{
    ehco "mysql安装"
    cd /usr/local/src/
    ./mysql.sh
}
function tomcat_menu ()
{
    echo "tomcat"
    cd /usr/lcoal/src/
    ./tom.sh
}
menu