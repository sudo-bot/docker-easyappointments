IMAGE_TAG ?= docker-easyappointments
TEST_ADDR ?= http://easyappointments

.PHONY: docker-build docker-test run-test cleanup-test test

all: docker-build docker-test

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--tag $(IMAGE_TAG) \
		--pull

docker-test: test

test: run-test cleanup-test

run-test:
	TEST_ADDR="${TEST_ADDR}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	docker-compose -f docker-compose-latest.test.yml up --exit-code-from=sut --abort-on-container-exit

cleanup-test:
	@echo "Stopping and removing the container"
	TEST_ADDR="${TEST_ADDR}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	docker-compose -f docker-compose-latest.test.yml down
