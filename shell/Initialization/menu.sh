#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|****************多功能主菜单**************|
-------------------------------------------
`echo -e "\033[35m 1)系统检测\033[0m"`
`echo -e "\033[35m 2)系统初始化\033[0m"`
`echo -e "\033[35m 3)应用\033[0m"`
`echo -e "\033[35m 4)其他\033[0m"`
`echo -e "\033[35m 5)退出\033[0m"`
EEE
read -p "选择应用: " num1
case $num1 in
  1)
    echo "系统检测"
      ppp_menu
      ;;
  2)
     echo "系统初始化"
       nnn_menu
       ;;
  3)
     echo "应用"
      yyy_menu
      ;;
  4)
     echo "其他"
      mmm_menu
      ;;
   5)
     exit 0
esac
}
function ppp_menu ()
{
/usr/bin/sh ./testing.sh
}
function nnn_menu ()
{
/usr/bin/sh ./initial.sh
}
function yyy_menu ()
{
/usr/bin/sh ./application.sh
}
function mmm_menu ()
{
echo "其他"
}
menu