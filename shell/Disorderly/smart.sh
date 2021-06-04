#!/bin/bash
#shell菜单
. /etc/init.d/functions
function smart_menu()
{
    cat << EOF
-------------------------------------------------------
|****************智能桌面(package.tar.gz)**************|
-------------------------------------------------------
`echo -e "\033[35m 1)nginx-1.12.1\033[0m"`
`echo -e "\033[35m 2)mysql-5.7.21\033[0m"`
`echo -e "\033[35m 3)php-5.6.35\033[0m"`
`echo -e "\033[35m 4)nginx-1.12.1+mysql-5.7.21\033[0m"`
`echo -e "\033[35m 5)nginx-1.12.1+php-5.6.35\033[0m"`
`echo -e "\033[35m 6)mysql-5.7.21+php-5.6.35\033[0m"`
`echo -e "\033[35m 7)退出\033[0m"`
`echo -e "\033[35m X）返回上一级目录\033[0m"`
EOF
read -p "请输入编号：" num2
case $num2 in
 1)
  echo "nginx安装"
  nginx_menu
  ;;
 2)
  echo "mysql安装"
  mysql_menu
  ;;
 3)
  echo "php安装"
  php_menu
  ;;
 4)
  echo "nginx+mysql安装"
  nginx_menu
  mysql_menu
  ;;
 5)
  echo "nginx+php安装"
  nginx_menu
  php_menu
  nginx_menu
  ;;
 6）
  echo "mysql+php安装"
  mysql_menu
  mysql_menu
  ;;
 7)
  exit 0
 x|X)
    echo -e "\033[32m---------返回上一级目录------->\033[0m"
    menu
    ;;
 *)
    echo -e "请输入正确编号"
    smart_menu
esac
}
function nginx_menu ()
{
    echo "调用nginx安装脚本"
    cd /usr/lcoal/src/
    ./nginx.sh
}
function mysql_menu ()
{
    echo "调用mysql安装脚本"
    cd /usr/lcoal/src/
    ./mysql.sh
}
function php_menu ()
{
    echo "调用mysql安装脚本"
    cd /usr/local/src/
    ./php.sh
}
menu