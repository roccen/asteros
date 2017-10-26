.ONESHELL:
SHELL = /bin/bash
.SHELLFLAGS += -e

MAIN_TARGET = isc-dhcp-common_$(ISC_DHCP_VERSION)_$(SONiC_ARCH).deb
DERIVED_TARGETS = isc-dhcp-relay_$(ISC_DHCP_VERSION)_$(SONiC_ARCH).deb

$(addprefix $(DEST)/, $(MAIN_TARGET)): $(DEST)/% :
	# Remove any stale files
	rm -rf ./isc-dhcp

	wget -nc $(repos_url)/pool/main/i/isc-dhcp/isc-dhcp_4.3.1.orig.tar.gz
	wget -nc $(repos_url)/pool/main/i/isc-dhcp/isc-dhcp_$(ISC_DHCP_VERSION).debian.tar.xz
	wget -nc $(repos_url)/pool/main/i/isc-dhcp/isc-dhcp_$(ISC_DHCP_VERSION).dsc

	dpkg-source -x isc-dhcp_$(ISC_DHCP_VERSION).dsc
	patch -p1 < isc-dhcp-4.3.1_dhcrelay-custom-circuit_id-remote_id-and-bridge-iface-support.patch
	pushd isc-dhcp-4.3.1
	dpkg-buildpackage -d -rfakeroot -b -us -uc -j$(SONIC_CONFIG_MAKE_JOBS)
	popd

	# Move the newly-built .deb packages to the destination directory
	mv $* $(DERIVED_TARGETS) $(DEST)/

$(addprefix $(DEST)/, $(DERIVED_TARGETS)): $(DEST)/% : $(DEST)/$(MAIN_TARGET)
