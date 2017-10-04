###############################################################################
## Wrapper for starting make inside sonic-slave container
###############################################################################

SHELL = /bin/bash

USER := $(shell id -un)
PWD := $(shell pwd)

SONiC_ARCH = amd64

# Remove lock file in case previous run was forcefully stopped
$(shell rm -f .screen)

MAKEFLAGS += -B

SLAVE_BASE_TAG = $(shell shasum sonic-slave/Dockerfile | awk '{print substr($$1,0,11);}')
SLAVE_TAG = $(shell cat sonic-slave/Dockerfile.user sonic-slave/Dockerfile | shasum | awk '{print substr($$1,0,11);}')
SLAVE_BASE_IMAGE = sonic-slave-base
SLAVE_IMAGE = sonic-slave-$(USER)

DOCKER_RUN := docker run --rm=true --privileged \
    -v $(PWD):/sonic \
    -w /sonic \
    -i$(if $(TERM),t,)

DOCKER_BASE_BUILD = docker build \
		    --build-arg repos_url="http://mirrors.163.com/debian" \
		    --build-arg sec_url="http://mirrors.163.com/debian-security" \
		    --build-arg file_url="http://192.168.0.99/files" \
		    -t $(SLAVE_BASE_IMAGE) \
		    sonic-slave && \
		    docker tag $(SLAVE_BASE_IMAGE):latest $(SLAVE_BASE_IMAGE):$(SLAVE_BASE_TAG)

DOCKER_BUILD = docker build --no-cache \
	       --build-arg user=$(USER) \
	       --build-arg uid=$(shell id -u) \
	       --build-arg guid=$(shell id -g) \
	       --build-arg hostname=$(shell echo $$HOSTNAME) \
	       -t $(SLAVE_IMAGE) \
	       -f sonic-slave/Dockerfile.user \
	       sonic-slave && \
	       docker tag $(SLAVE_IMAGE):latest $(SLAVE_IMAGE):$(SLAVE_TAG)

.PHONY: sonic-slave-build sonic-slave-bash

.DEFAULT_GOAL :=  all

%::
	@docker inspect --type image $(SLAVE_BASE_IMAGE):$(SLAVE_BASE_TAG) &> /dev/null || \
	    { echo Image $(SLAVE_BASE_IMAGE):$(SLAVE_BASE_TAG) not found. Building... ; \
	    $(DOCKER_BASE_BUILD) ; }
	@docker inspect --type image $(SLAVE_IMAGE):$(SLAVE_TAG) &> /dev/null || \
	    { echo Image $(SLAVE_IMAGE):$(SLAVE_TAG) not found. Building... ; \
	    $(DOCKER_BUILD) ; }
	@$(DOCKER_RUN) $(SLAVE_IMAGE):$(SLAVE_TAG) make \
	    -f slave.mk \
	    PLATFORM=$(PLATFORM) \
	    BUILD_NUMBER=$(BUILD_NUMBER) \
	    ENABLE_DHCP_GRAPH_SERVICE=$(ENABLE_DHCP_GRAPH_SERVICE) \
	    SHUTDOWN_BGP_ON_START=$(SHUTDOWN_BGP_ON_START) \
	    SONIC_ENABLE_SYNCD_RPC=$(ENABLE_SYNCD_RPC) \
	    PASSWORD=$(PASSWORD) \
	    USERNAME=$(USERNAME) \
	    $@

sonic-slave-build :
	$(DOCKER_BASE_BUILD)
	$(DOCKER_BUILD)

sonic-slave-bash :
	@docker inspect --type image $(SLAVE_BASE_IMAGE):$(SLAVE_BASE_TAG) &> /dev/null || \
	    { echo Image $(SLAVE_BASE_IMAGE):$(SLAVE_BASE_TAG) not found. Building... ; \
	    $(DOCKER_BASE_BUILD) ; }
	@docker inspect --type image $(SLAVE_IMAGE):$(SLAVE_TAG) &> /dev/null || \
	    { echo Image $(SLAVE_IMAGE):$(SLAVE_TAG) not found. Building... ; \
	    $(DOCKER_BUILD) ; }
	@$(DOCKER_RUN) -t $(SLAVE_IMAGE):$(SLAVE_TAG) bash
