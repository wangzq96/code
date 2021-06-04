#!/bin/bash
#内核参数
cat <<WWW >>/etc/sysctl.conf
net.ipv4.ip_forward = 0
net.ipv4.ip_local_port_range = 1024 65000

kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736

vm.swappiness = 0

net.ipv4.conf.default.accept_source_route = 0
net.ipv4.neigh.default.gc_stale_time=120
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.lo.arp_announce=2

net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.tcp_timestamps=0
net.core.netdev_max_backlog = 262144
WWW
#系统打开文件最大值参数
cat <<EOF >>/etc/security/limits.conf
# End of file
*    soft    nofile    65536
*    hard    nofile    65536
*    soft    noproc    10240
*    hard    noproc    10240
EOF
sysctl -p
tail /etc/security/limits.conf