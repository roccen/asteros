# mpdecimal package

MPDECIMAL_VERSION = 2.4.2
MPDECIMAL_VERSION_FULL = $(MPDECIMAL_VERSION)-1

export MPDECIMAL_VERSION MPDECIMAL_VERSION_FULL

LIBMPDECIMAL = libmpdec2_$(MPDECIMAL_VERSION_FULL)_$(SONiC_ARCH).deb
$(LIBMPDECIMAL)_SRC_PATH = $(SRC_PATH)/mpdecimal
SONIC_MAKE_DEBS += $(LIBMPDECIMAL)

LIBMPDECIMAL_DEV = libmpdec-dev_$(MPDECIMAL_VERSION_FULL)_$(SONiC_ARCH).deb
$(eval $(call add_derived_package,$(LIBMPDECIMAL),$(LIBMPDECIMAL_DEV)))
