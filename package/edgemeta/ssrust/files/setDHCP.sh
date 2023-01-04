#/bin/sh

uci delete dhcp.@dnsmasq[0].boguspriv='1'
uci delete dhcp.@dnsmasq[0].filterwin2k='0'
uci delete dhcp.@dnsmasq[0].nonegcache='0'
uci delete dhcp.@dnsmasq[0].resolvfile='/tmp/resolv.conf.d/resolv.conf.auto'
uci delete dhcp.@dnsmasq[0].nonwildcard='1'
uci set dhcp.@dnsmasq[0].server='127.0.0.1#15353'
uci set dhcp.@dnsmasq[0].nohosts='1'
uci set dhcp.@dnsmasq[0].noresolv='1'
uci set dhcp.@dnsmasq[0].cachesize='10000'
uci set dhcp.@dnsmasq[0].min_cache_ttl='3600'
uci set dhcp.@dnsmasq[0].dnsforwardmax='1000'
uci commit dhcp
/etc/init.d/dnsmasq restart

