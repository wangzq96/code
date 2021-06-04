#!/bin/bash
function menu ()
{
    cat << EEE
-------------------------------------------
|*******************redis*****************|
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
echo "yum依赖"
yum install -y telnet gcc c++ gcc-c++ automake autoconf libtool make net-tools supervisor epel-release &>/dev/null
cd /usr/local/src/
echo "下载压缩包4.0.9版本"
wget -c http://download.redis.io/releases/redis-4.0.9.tar.gz &>/dev/null
sleep 5s
echo "解压"
tar xf redis-4.0.9.tar.gz
mv /usr/local/src/redis-4.0.9   /usr/local/redis
cd /usr/local/redis/
echo "编辑"
make
echo "修改配置文件"
cat > /usr/local/redis/redis.conf << EOF
bind 0.0.0.0
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
#requirepass !qazxsw2
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile "/usr/local/redis/redis_6379.log"
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir ./
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble no
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
EOF
echo "supervisord---redis.ini"
cat > /etc/supervisord.d/redis.ini << EOF
[program:redis]
startsecs = 1
autostart=true
autorestart=true
command=/usr/local/redis/src/redis-server /usr/local/redis/redis.conf
EOF
echo "启动"
systemctl status supervisord.service && systemctl enable supervisord.service &>/dev/null
}
function www_menu ()
{
echo "判断是否安装docker"
Docker=`which docker`
if [ "$Docker" == 0 ]
then
  echo -e  "Please install docker"
  exit
else
  echo -e  "yes"
fi
mkdir -p /data/redis
cat > /data/redis/docker-compose.yml << EOF
version: "3"
services:
  redis:
    container_name: "redis"
    restart: always
    image: harbor02.sllhtv.com/shulian/redis:1.1.3
    volumes:
      - /data/redis/redis.conf:/usr/local/etc/redis/redis.conf
      - /data/redis/data:/data
    ports:
      - "6379:6379"
EOF
cd /data/redis/
/usr/local/bin/docker-compose up -d redis
}
menu