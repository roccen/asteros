.ONESHELL:

SHELL = /bin/bash

KVERSION_SHORT = 4.9.0-0.bpo.3
KVERSION = $(KVERSION_SHORT)-$(SONiC_ARCH)
KERNEL_VERSION = 4.9.30
KERNEL_SUBVERSION = 2+deb9u5~bpo8+1


MAIN_TARGET = linux-headers-$(KVERSION_SHORT)-common_$(KERNEL_VERSION)-$(KERNEL_SUBVERSION)_all.deb
DERIVED_TARGETS = linux-headers-$(KVERSION)_$(KERNEL_VERSION)-$(KERNEL_SUBVERSION)_$(SONiC_ARCH).deb \
                 linux-image-$(KVERSION)_$(KERNEL_VERSION)-$(KERNEL_SUBVERSION)_$(SONiC_ARCH).deb

DSC_FILE = linux_$(KERNEL_VERSION)-$(KERNEL_SUBVERSION).dsc
ORIG_FILE = linux_$(KERNEL_VERSION).orig.tar.xz
DEBIAN_FILE = linux_$(KERNEL_VERSION)-$(KERNEL_SUBVERSION).debian.tar.xz
URL = http://mirrors.163.com/debian/pool/main/l/linux
BUILD_DIR=linux-$(KERNEL_VERSION)

DSC_FILE_URL = $(URL)/$(DSC_FILE)
DEBIAN_FILE_URL = $(URL)/$(DEBIAN_FILE)
ORIG_FILE_URL = $(URL)/$(ORIG_FILE)

$(addprefix $(DEST)/, $(MAIN_TARGET)): $(DEST)/% :
	# Obtaining the Debian kernel source
	rm -rf $(BUILD_DIR)
	wget -c -O $(DSC_FILE) $(DSC_FILE_URL)
	wget -c -O $(ORIG_FILE) $(ORIG_FILE_URL)
	wget -c -O $(DEBIAN_FILE) $(DEBIAN_FILE_URL)

	dpkg-source -x $(DSC_FILE)

	pushd $(BUILD_DIR)
	# patch debian changelog and update kernel package version
	#patch -p0 < ../patch/changelog.patch
	perl -pi -e 's/debug-info:\s+true/debug-info: false/' debian/config/$(SONiC_ARCH)/defines

	# re-generate debian/rules.gen, requires kernel-wedge
	debian/bin/gencontrol.py

	
	# generate linux build file for $(SONiC_ARCH)_none_$(SONiC_ARCH)
	fakeroot make -f debian/rules.gen setup_$(SONiC_ARCH)_none_$(SONiC_ARCH)

	# Applying patches and configuration changes
	git init
	git add -f *
	git add debian/build/build_$(SONiC_ARCH)_none_$(SONiC_ARCH)/.config -f
	git commit -m "unmodified debian source"
	stg init
	#stg import -s ../patch/series

	# Building a custom kernel from Debian kernel source
	fakeroot make -f debian/rules.gen -j $(shell nproc) binary-arch_$(SONiC_ARCH)_none
	fakeroot make -f debian/rules.gen binary-indep_none
	popd

ifneq ($(DEST),)
	mv $(DERIVED_TARGETS) $* $(DEST)/
endif

$(addprefix $(DEST)/, $(DERIVED_TARGETS)): $(DEST)/% : $(DEST)/$(MAIN_TARGET)
