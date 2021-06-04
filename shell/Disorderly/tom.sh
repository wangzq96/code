#!/bin/bash
cd /data/
wget 114.251.62.161:50801/tomcat-5120.tar.gz
tar xf tomcat-5120.tar.gz
cd tomcat-5120
cd conf
echo "username用户是bims"
find "/data/tomcat-5120/conf/server.xml"|xargs perl -pi -e 's|username=.*|username="bims"|g'
echo "password密码abc.com"
find "/data/tomcat-5120/conf/server.xml"|xargs perl -pi -e 's|password=.*|username="abc.com"|g'
echo "url的地址的更换，脚本中是注释的，补充下url的地址在执行"
#find ""/data/tomcat-5120/conf/server.xml"|xargs perl -pi -e 's|url=.*|url="jdbc:mysql://127.0.0.1:3307/bims?useUnicode=true&amp;zeroDateTimeBehavior=convertToNull&amp;characterEncoding=UTF-8&amp;characterSetResults=UTF-8&amp;autoReconnect=true"|g'
ehco "修改JAVA_HOME的路径"
sed -i '96c JAVA_HOME=/usr/jdk1.8.0_171/' /data/tomcat-5120/bin/catalina.sh
A=`grep 'JAVA_HOME=.*jdk*' catalina.sh`
find "/data/bin/catalina.sh"|xargs perl -pi -e 's|$A|JAVA_HOME=/usr/jdk1.8.0_171/|g'