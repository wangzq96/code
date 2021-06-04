#!/bin/bash
echo "jdk-1.8"
cd /usr/
wget  114.251.62.161:50801/jdk-8u66-linux-x64.rpm
cd /usr/
rpm -ivh jdk-8u66-linux-x64.rpm
cat >>/etc/profile<<EOF
JAVA_HOME=/usr/jdk1.8.0_171/
PATH=$JAVA_HOME/bin:$PATH
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME
export PATH
export CLASSPATH
EOF
source /etc/profile
java -version