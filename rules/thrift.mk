# thrift package

THRIFT_VERSION = 0.9.3
THRIFT_VERSION_FULL = $(THRIFT_VERSION)-2

LIBTHRIFT = libthrift-$(THRIFT_VERSION)_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb
$(LIBTHRIFT)_SRC_PATH = $(SRC_PATH)/thrift
SONIC_MAKE_DEBS += $(LIBTHRIFT)

LIBTHRIFT_DEV = libthrift-dev_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb
$(eval $(call add_derived_package,$(LIBTHRIFT),$(LIBTHRIFT_DEV)))

PYTHON_THRIFT = python-thrift_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb
$(eval $(call add_derived_package,$(LIBTHRIFT),$(PYTHON_THRIFT)))

THRIFT_COMPILER = thrift-compiler_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb
$(eval $(call add_derived_package,$(LIBTHRIFT),$(THRIFT_COMPILER)))
