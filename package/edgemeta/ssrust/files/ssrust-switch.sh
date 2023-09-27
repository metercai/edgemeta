#!/bin/sh 

SSRUST_NAME="ssrust"
PROXYFILE=proxy-gfw.conf
ANTIADFILE=anti-ad-for-dnsmasq.conf

enable_rules() {
  nft list table ip ssrust > /dev/null 2>&1 ;
  if [ $? -ne 0 ] || [ ! -f "/var/run/ssrust.pid" ];then
      echo "ssrust must be running at first!"
      exit 1
  fi
  JUMP_FLAG=`nft -a list chain ssrust Output | grep "jump ProxyFilter"`
  if [ -z "$JUMP_FLAG" ]; then
      nft add rule ip ssrust Output ip protocol tcp counter jump ProxyFilter
      nft add rule ip ssrust Output ip protocol udp counter jump ProxyFilter
  fi
  JUMP_FLAG=`nft -a list chain ssrust PreRouting | grep "jump ProxyFilter"`                 
  if [ -z "$JUMP_FLAG" ]; then                                                          
      nft add rule ip ssrust PreRouting ip protocol tcp counter jump ProxyFilter
      nft add rule ip ssrust PreRouting ip protocol udp counter jump ProxyFilter
      ip -4 rule add fwmark 0x2333 table 233 protocol kernel
      ip -4 route add local default dev lo table 233
  fi
  echo "SSRust rules are enabled ！"

  cp /etc/ssrust/$PROXYFILE /var/dnsmasq.d/
  cp -f /etc/ssrust/$ANTIADFILE /var/dnsmasq.d/

  `/etc/init.d/dnsmasq restart`
}

disable_rules() {
  nft flush chain ip ssrust Output
  nft flush chain ip ssrust PreRouting
  while ip -4 rule del fwmark 1 table 233 2>/dev/null; do true; done
  ip -4 route flush table 233 2>/dev/null || true
  echo "SSRust rules in nftables are cancelled !"

  rm /var/dnsmasq.d/$PROXYFILE
  `/etc/init.d/dnsmasq restart`
}

status() {
        if [ "`ps -ef | pgrep $SSRUST_NAME | wc -l`" -eq "0" ]; then
                echo "$SSRUST_NAME not running"
        else
                echo "$SSRUST_NAME is running, pid is `ps -ef | pgrep $SSRUST_NAME | xargs`"
        fi  
}

case "$1" in
"up")
	enable_rules
	;;
"down")
	disable_rules
	;;
"status")
	status
	;;
*)
	echo "usage...."
	;;
esac
exit 0
