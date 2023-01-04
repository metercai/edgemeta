#
# Copyright (C) 2021 honwen <https://github.com/honwen>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ssrust
PKG_VERSION:=1.14.4
PKG_RELEASE:=20220417

PKG_LIBC:=musl
ifeq ($(ARCH),arm)
  PKG_LIBC:=musleabi

  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_LIBC:=musleabihf
  endif
endif

PKG_SOURCE:=shadowsocks-v$(PKG_VERSION).$(ARCH)-unknown-linux-$(PKG_LIBC).tar.xz
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
/etc/$(PKG_NAME)/ssrust.acl
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ssservice $(1)/usr/bin/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/$(PKG_NAME)
	$(INSTALL_CONF) ./files/local.json $(1)/etc/$(PKG_NAME)/local.json
	$(INSTALL_CONF) ./files/log4rs.yaml $(1)/etc/$(PKG_NAME)/log4rs.yaml
	$(INSTALL_CONF) ./files/ssrust.acl $(1)/etc/$(PKG_NAME)/ssrust.acl
	$(INSTALL_CONF) ./files/bypass.small.acl $(1)/etc/$(PKG_NAME)/bypass.small.acl
	$(INSTALL_CONF) ./files/bypass.big.acl $(1)/etc/$(PKG_NAME)/bypass.big.acl
	$(INSTALL_CONF) ./files/resolv.conf $(1)/etc/$(PKG_NAME)/resolv.conf
	$(SED) "s#%SSSPWD%#$(SSSPWD)#g" $(1)/etc/$(PKG_NAME)/local.json
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init.d/ssrust $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_BIN) ./files/resize.sh $(1)/usr/bin/
ifeq ($(CONFIG_SS_RUST_TOOLS),y)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ssurl $(1)/usr/bin/
endif
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
