# lldpd package

LLDPD_VERSION = 0.9.5-0

LLDPD = lldpd_$(LLDPD_VERSION)_$(SONiC_ARCH).deb
$(LLDPD)_DEPENDS += $(LIBSNMP_DEV)
$(LLDPD)_RDEPENDS += $(LIBSNMP)
$(LLDPD)_SRC_PATH = $(SRC_PATH)/lldpd
SONIC_DPKG_DEBS += $(LLDPD)

LIBLLDPCTL = liblldpctl-dev_$(LLDPD_VERSION)_$(SONiC_ARCH).deb
$(eval $(call add_derived_package,$(LLDPD),$(LIBLLDPCTL)))
