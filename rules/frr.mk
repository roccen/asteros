# FRRouting (frr) package

FRR_VERSION = 3.0
export FRR_VERSION

FRR = frr_$(FRR_VERSION)_$(SONiC_ARCH).deb
$(FRR)_DEPENDS += $(LIBSNMP_DEV)
$(FRR)_SRC_PATH = $(SRC_PATH)/sonic-frr
SONIC_MAKE_DEBS += $(FRR)
