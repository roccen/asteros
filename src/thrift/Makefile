SHELL = /bin/bash
.ONESHELL:
.SHELLFLAGS += -e

THRIFT_VERSION = 0.9.3
THRIFT_VERSION_FULL = $(THRIFT_VERSION)-2

MAIN_TARGET = libthrift-$(THRIFT_VERSION)_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb
DERIVED_TARGETS = libthrift-dev_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb \
		  python-thrift_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb \
		  thrift-compiler_$(THRIFT_VERSION_FULL)_$(SONiC_ARCH).deb

$(addprefix $(DEST)/, $(MAIN_TARGET)): $(DEST)/% :
	rm -rf thrift-$(THRIFT_VERSION)

	wget -nc $(repos_url)/pool/main/t/thrift/thrift_$(THRIFT_VERSION).orig.tar.gz
	wget -nc $(repos_url)/pool/main/t/thrift/thrift_$(THRIFT_VERSION_FULL).debian.tar.xz
	wget -nc $(repos_url)/pool/main/t/thrift/thrift_$(THRIFT_VERSION_FULL).dsc

	dpkg-source -x thrift_$(THRIFT_VERSION_FULL).dsc
	pushd thrift-$(THRIFT_VERSION)
	patch -p1 < ../patch/THRIFT-3577-assertion-failed.patch
	DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -d -rfakeroot -b -us -uc -j$(SONIC_CONFIG_MAKE_JOBS)
	popd

	mv $(DERIVED_TARGETS) $* $(DEST)/

$(addprefix $(DEST)/, $(DERIVED_TARGETS)): $(DEST)/% : $(DEST)/$(MAIN_TARGET)
