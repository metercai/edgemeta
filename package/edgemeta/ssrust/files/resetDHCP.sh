#/bin/sh

uci delete dhcp.@dnsmasq[0].server
uci delete dhcp.@dnsmasq[0].nohosts
uci delete dhcp.@dnsmasq[0].noresolv
uci delete dhcp.@dnsmasq[0].cachesize
uci delete dhcp.@dnsmasq[0].min_cache_ttl
uci delete dhcp.@dnsmasq[0].dnsforwardmax
uci set dhcp.@dnsmasq[0].boguspriv='1'
uci set dhcp.@dnsmasq[0].filterwin2k=‘0’
uci set dhcp.@dnsmasq[0].nonegcache=‘0’
uci set dhcp.@dnsmasq[0].resolvfile='/tmp/resolv.conf.d/resolv.conf.auto'
uci set dhcp.@dnsmasq[0].nonwildcard='1'
uci commit dhcp
/etc/init.d/dnsmasq restart

