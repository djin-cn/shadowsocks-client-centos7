#!/bin/bash
#run in server
#docker run -e PASSWORD=<password> -p<port>:8388 -p<port>:8388/udp -d shadowsocks/shadowsocks-libev
#run in client
yum -y install epel-release

yum -y install python-pip
#pip install --upgrade pip

pip install shadowsocks
mkdir /etc/shadowsocks

#"server": "<x.x.x.x>", # Shadowsocks server ip/domain
#"server_port": <port>, # Shadowsocks server port
#"local_address": "127.0.0.1", # local ip
#"local_port": 1080, # local port
#"password": "<password>", # Shadowsocks password
#"timeout": 300, # wait timeout
#"method": "aes-256-cfb", # encryption mode
#"fast_open": false, # true or false. reduce latency with open fastopen, require linux core 3.7+
#"workers": 1 # work thread
echo "{
    \"server\": \"$1\",
    \"server_port\": $2,
    \"local_address\": \"127.0.0.1\",
    \"local_port\": 1080,
    \"password\": \"$3\",
    \"timeout\": 300,
    \"method\": \"aes-256-cfb\",
    \"fast_open\": false,
    \"workers\": 1
}" > /etc/shadowsocks/shadowsocks.json

echo '[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target'>/etc/systemd/system/shadowsocks.service

systemctl enable shadowsocks.service
systemctl start shadowsocks.service
systemctl status shadowsocks.service

yum install privoxy -y
systemctl enable privoxy
systemctl start privoxy
systemctl status privoxy
echo 'forward-socks5t / 127.0.0.1:1080 .' >> /etc/privoxy/config

#if this is docker container, then append /etc/bashrc
echo '
PROXY_HOST=127.0.0.1
export all_proxy=http://$PROXY_HOST:8118
export ftp_proxy=http://$PROXY_HOST:8118
export http_proxy=http://$PROXY_HOST:8118
export https_proxy=http://$PROXY_HOST:8118
export no_proxy=localhost,172.16.0.0/16,172.17.0.0/16,192.168.0.0/16,127.0.0.1,10.10.0.0/16
' >> /etc/profile
source /etc/profile
