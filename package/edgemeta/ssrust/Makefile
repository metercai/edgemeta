#
# Copyright (C) 2021 honwen <https://github.com/honwen>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ssrust
PKG_VERSION:=1.16.2
PKG_RELEASE:=20230928

PKG_LIBC:=musl
ifeq ($(ARCH),arm)
  PKG_LIBC:=musleabi

  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_LIBC:=musleabihf
  endif
endif

PKG_SOURCE:=ssrust-v$(PKG_VERSION).$(ARCH)-unknown-linux-$(PKG_LIBC).tar.xz
PKG_SOURCE_URL:=https://github.com/metercai/SSRust/releases/download/v$(PKG_VERSION)-dns/
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)
PKG_HASH:=skip

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy - Rust.
	URL:=https://github.com/shadowsocks/shadowsocks-rust
endef

define Package/$(PKG_NAME)/config
	config SS_RUST_TOOLS
		depends on PACKAGE_ssrust
		bool "Build ssurl"
endef

define Package/$(PKG_NAME)/description
This is a port of shadowsocks.
endef

define Build/Prepare
	tar -C $(PKG_BUILD_DIR)/ -Jxf $(DL_DIR)/$(PKG_SOURCE)
endef

define Build/Compile
	echo "$(PKG_NAME) Compile Skiped!"
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	if [ -f /etc/uci-defaults/$(PKG_NAME) ]; then
		( . /etc/uci-defaults/$(PKG_NAME) ) && \
		rm -f /etc/uci-defaults/$(PKG_NAME)
	fi
fi
exit 0
endef

define Package/$(PKG_NAME)/conffiles
/etc/$(PKG_NAME)/local.json
/etc/$(PKG_NAME)/log4rs.yaml
/etc/$(PKG_NAME)/proxy.acl
/etc/$(PKG_NAME)/bypass.iplist
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ssservice $(1)/usr/bin/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/$(PKG_NAME)
	$(INSTALL_CONF) ./files/local.json.default $(1)/etc/$(PKG_NAME)/local.json
	$(INSTALL_CONF) ./files/log4rs.yaml $(1)/etc/$(PKG_NAME)/
	$(INSTALL_CONF) ./files/bypass.iplist $(1)/etc/$(PKG_NAME)/
	$(INSTALL_CONF) ./files/proxy.acl $(1)/etc/$(PKG_NAME)/
	$(INSTALL_CONF) ./files/proxy-gfw.conf $(1)/etc/$(PKG_NAME)/
	$(INSTALL_CONF) ./files/anti-ad-for-dnsmasq.conf $(1)/etc/$(PKG_NAME)/
	$(SED) "s#%SSSERVER%#$(SSSERVER)#g" $(1)/etc/$(PKG_NAME)/local.json
	$(SED) "s#%SSPORT%#$(SSPORT)#g" $(1)/etc/$(PKG_NAME)/local.json
	$(SED) "s#%SSPWD%#$(SSPWD)#g" $(1)/etc/$(PKG_NAME)/local.json
	$(SED) "s#%SSSERVER2%#$(SSSERVER2)#g" $(1)/etc/$(PKG_NAME)/local.json
	$(SED) "s#%SSPWD2%#$(SSPWD2)#g" $(1)/etc/$(PKG_NAME)/local.json
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init.d/ssrust $(1)/etc/init.d/$(PKG_NAME)
	$(SED) "s#%SSSERVER%#$(SSSERVER)#g" $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_BIN) ./files/ssrust-switch.sh $(1)/usr/bin/
ifeq ($(CONFIG_SS_RUST_TOOLS),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ssurl $(1)/usr/bin/
endif
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
