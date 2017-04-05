ACCOUNT=hbokh
IMAGE=docker-typo3-cms
VERSION=7.6.16
#BUILD_DATE=`date -u +"%Y%m%dT%H%MZ"`
BUILD_DATE=`date -u +"%Y%m%d"`
VCS_REF=`git rev-parse --short HEAD`
#TAG=${VERSION}-${BUILD_DATE}-git-${VCS_REF}
TAG=${VERSION}-${BUILD_DATE}

.PHONY: all default
default: build
all: build tag push

build:
	@docker build \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		-t $(IMAGE) .

tag:
	@docker tag $(IMAGE) $(ACCOUNT)/$(IMAGE):$(TAG)
	@docker tag $(IMAGE) $(ACCOUNT)/$(IMAGE):latest

push:
	@docker push $(ACCOUNT)/$(IMAGE):$(TAG)
	@docker push $(ACCOUNT)/$(IMAGE):latest
