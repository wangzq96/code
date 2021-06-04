#!/bin/sh
a="smart_auth smart_cdn_server smart_city smart_config smart_language smart_role smart_role_auth smart_weather_city Tables_in_smart"
b=`mysql -u root -p'123.com' smart -e "show tables"`
host='locahost'
user='root'
passwd='123.com'
  for i in $b;do
      type='true'
	for t in $a;do
	   if [ ${i} = ${t} ];then
	   type="false"
   	   fi
	done
   	   if [ $type = "true" ];then
	   echo "truncate table $i"
		mysql -u $user -p${passwd} smart -e "truncate table $i"
	   fi
	done
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('1', '央广银河', '1', '1', '1534492121', '', '1', '央广银河');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('2', '百事通', '1', '1', '1534492136', '', '2', '百事通');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('3', '芒果TV', '1', '1', '1534492149', '', '3', '芒果TV');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('4', '未来电视', '1', '1', '1534492161', '', '4', '未来电视');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('5', 'CIBN', '1', '1', '1534492531', '', '5', '中国国际广播电视台');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('6', '华数', '1', '1', '1534492568', '', '6', '华数');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_license_tag VALUES ('7', '云视听', '1', '1', '1534492582', '', '7', '云视听');"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_member_role VALUES (1,1,1,0,0);"
mysql  -u $user -p${passwd} smart -e "INSERT INTO smart_member VALUES (1,'administrator','b506d8565d2d1549d93268c02fbbf76c','ALL',0.00,'sllh@digitlink.cn',1,1,1,'13588888881','layout,marquee,main_welcome,second_welcome','volumn,recovery,turn_on_light,turn_on_color,power_up,remote_control_on,usb_eject,remote_control_keys,sound_on,auto_search_channel,turn_on_signal_on,channel_list,suspend_led,open_video_ad',1,0,1521171228,1461229864,1542288274,0,3,1543993030,1);"