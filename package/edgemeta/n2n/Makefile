#
# Copyright (C) 2021 - ntop.org and contributors
#

include $(TOPDIR)/rules.mk

PKG_NAME:=n2n
PKG_VERSION:=3.1.2
PKG_RELEASE:=202212
PKG_REV:=cd7b3b4

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_REV).tar.gz

# These are defaults for compiling without any environmental overrides
# (eg, the github action calculates the correct overrides for each build)
PKG_SOURCE_URL:=https://github.com/ntop/n2n
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MIRROR_HASH:=skip

# Apply overrides from the build environment
ifdef N2N_PKG_SOURCE_URL
    PKG_SOURCE_URL:=$(N2N_PKG_SOURCE_URL)
endif
ifdef N2N_PKG_SOURCE_VERSION
    PKG_SOURCE_VERSION:=$(N2N_PKG_SOURCE_VERSION)
endif
ifdef N2N_PKG_VERSION
    PKG_VERSION:=$(N2N_PKG_VERSION)
endif

PKG_MAINTAINER:=Meter Cai<925457@qq.com>
PKG_LICENSE:=GPL3

# autogen fix
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk
CONFIGURE_ARGS += --with-openssl --with-zstd --enable-cap --enable-pcap --enable-pthread --enable-miniupnp CFLAGS="-O3 -march=native"

define Package/n2n/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=N2N Peer-to-peer VPN
  URL:=http://www.ntop.org/n2n
  SUBMENU:=VPN
  DEPENDS+=+libpcap +libcap
endef

define Package/n2n-edge
  $(call Package/n2n/Default)
  TITLE+= client (edge node)
  DEPENDS+=+kmod-tun
endef

define Package/n2n-supernode
  $(call Package/n2n/Default)
  TITLE+= server (supernode)
endef

define Package/n2n-edge/description
The client node for the N2N infrastructure
endef

define Package/n2n-supernode/description
The supernode for the N2N infrastructure
endef

define Build/Configure
	( cd $(PKG_BUILD_DIR); \
	./autogen.sh; \
	./configure )
endef

define Package/n2n-edge/conffiles
/etc/config/edge.conf
endef

define Package/n2n-edge/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/edge $(1)/usr/bin/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./etc/config/edge.conf $(1)/etc/config/$(PKG_NAME).conf
	$(SED) "s#%N2N_KEY%#$(N2N_KEY)#g" $(1)/etc/config/$(PKG_NAME).conf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./etc/init.d/edge $(1)/etc/init.d/$(PKG_NAME)
endef

define Package/n2n-supernode/conffiles
/etc/config/supernode.conf
endef

define Package/n2n-supernode/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/supernode $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/packages/openwrt/etc/init.d/supernode $(1)/etc/init.d/supernode
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/packages/etc/config/supernode.conf.sample $(1)/etc/config/supernode.conf
endef

$(eval $(call BuildPackage,n2n-edge))
$(eval $(call BuildPackage,n2n-supernode))
