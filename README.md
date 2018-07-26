# shadowsocks-client-centos7
shadowsocks client run in centos7 server

<H1>Usage</H1>
./shadowsocks.sh <server> <port> <password>

服务可以用官方提供的docker image
docker run -e PASSWORD=<password> -p<port>:8388 -p<port>:8388/udp -d shadowsocks/shadowsocks-libev
