ACCOUNT=hbokh
APP_NAME=docker-typo3-cms

default: docker_build

docker_build:
	@docker build \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		-t $(ACCOUNT)/$(APP_NAME):latest .
