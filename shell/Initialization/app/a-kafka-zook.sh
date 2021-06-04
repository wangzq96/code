#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|*****************kafka+zook***************|
-------------------------------------------
`echo -e "\033[35m 1)编辑安装\033[0m"`
`echo -e "\033[35m 2)docker容器\033[0m"`
`echo -e "\033[35m 3)退出\033[0m"`
EEE
read -p "选择应用: " num1
case $num1 in
  1)
    echo "编辑安装"
      qqq_menu
      ;;
  2)
     echo "docker容器"
       www_menu
       ;;
   3)
     exit 0
esac
}
function qqq_menu ()
{
echo "暂不提供"
}
function www_menu ()
{
IP=$( ip a | grep inet|grep -v 127.0.0.1|awk '{print $2}'|tr -d "addr:" | grep -E -w "^10" | awk -F '/' '{print $1}' | head -n 1 )
mkdir -p /data/kafka-zook/
cat > /data/kafka-zook/docker-compose.yml << EOF
version: '2'
services:
  zoo1:
    image: wurstmeister/zookeeper
    restart: unless-stopped
    hostname: zoo1
    ports:
      - "2181:2181"
    container_name: zookeeper

  kafka:
    image: wurstmeister/kafka
    restart: always
    ports:
      - "9092:9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: "$IP"
      KAFKA_ZOOKEEPER_CONNECT: "zoo1:2181"
      KAFKA_BROKER_ID: 1
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_CREATE_TOPICS: "origin:1:1"
    depends_on:
      - zoo1
    container_name: kafka
    volumes:
      - /data/kafka/logs:/opt/kafka/logs
EOF
cd /data/kafka-zook/
docker-compose up -d
}
menu