#!/bin/bash
echo "shulian.repo"
mkdir -p /etc/yum.repos.d/bak
cd /etc/yum.repos.d/
mv CentOS-* ./bak
mv epel-* ./bak
cat > /etc/yum.repos.d/shulian.repo << EOF
[shulian]
name=shulian
baseurl=http://repo01.ops01.sllhtv.com:50080/Centos76
gpgcheck=0
enabled=1
keepcache=0

[shulian-extra]
name=shulian-extra
baseurl=http://repo01.ops01.sllhtv.com:50080/extra
gpgcheck=0
enabled=1
keepcache=0
EOF
cd
yum repolist  &>/dev/null

echo "docker"
yum install -y yum-utils device-mapper-persistent-data lvm2  &>/dev/null
yum install docker-ce -y  &>/dev/null
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://kfq51tpx.mirror.aliyuncs.com"],
  "data-root": "/data/docker-dir"
}
EOF
systemctl daemon-reload && systemctl restart docker && systemctl enable docker

echo "harbor key"
mkdir -p /root/.docker
cat > /root/.docker/config.json << EOF
{
	"auths": {
		"harbor01.sllhtv.com": {
			"auth": "YWRtaW46SGFyYm9yMTIzNDU="
		},
		"harbor02.sllhtv.com:5443": {
			"auth": "QWRtaW46U2xsaHR2MTIz"
		}
	},
	"HttpHeaders": {
		"User-Agent": "Docker-Client/18.09.3 (linux)"
	}
}
EOF
echo "docker-compose"
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose  &>/dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/
docker-compose version