#!/bin/bash
yum -y install supervisor &>/dev/null
systemctl restart supervisord && systemctl enable supervisord && systemctl status supervisord