SHELL = /bin/bash
.ONESHELL:
.SHELLFLAGS += -e

KEXEC_TOOLS_VERSION = 2.0.14
KEXEC_TOOLS_VERSION_FULL = $(KEXEC_TOOLS_VERSION)-1

MAIN_TARGET = kexec-tools_$(KEXEC_TOOLS_VERSION_FULL)_$(SONiC_ARCH).deb
#DERIVED_TARGETS = libthrift-dev_$(KEXEC_TOOLS_VERSION_FULL)_$(SONiC_ARCH).deb \
		  python-thrift_$(KEXEC_TOOLS_VERSION_FULL)_$(SONiC_ARCH).deb \
		  thrift-compiler_$(KEXEC_TOOLS_VERSION_FULL)_$(SONiC_ARCH).deb

$(addprefix $(DEST)/, $(MAIN_TARGET)): $(DEST)/% :
	rm -rf kexec-tools-$(KEXEC_TOOLS_VERSION)

	wget -nc $(repos_url)/pool/main/k/kexec-tools/kexec-tools_$(KEXEC_TOOLS_VERSION).orig.tar.gz
	wget -nc $(repos_url)/pool/main/k/kexec-tools/kexec-tools_$(KEXEC_TOOLS_VERSION_FULL).debian.tar.xz
	wget -nc $(repos_url)/pool/main/k/kexec-tools/kexec-tools_$(KEXEC_TOOLS_VERSION_FULL).dsc

	dpkg-source -x kexec-tools_$(KEXEC_TOOLS_VERSION_FULL).dsc
	pushd kexec-tools-$(KEXEC_TOOLS_VERSION)
	#patch -p1 < ../patch/KEXEC_TOOLS-3577-assertion-failed.patch
	dpkg-buildpackage -d -rfakeroot -b -us -uc -j$(SONIC_CONFIG_MAKE_JOBS)
	popd

	mv $(DERIVED_TARGETS) $* $(DEST)/

$(addprefix $(DEST)/, $(DERIVED_TARGETS)): $(DEST)/% : $(DEST)/$(MAIN_TARGET)
