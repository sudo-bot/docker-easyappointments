IMAGE_TAG ?= docker-easyappointments
TEST_ADDR ?= 127.0.0.77:9099
CONTAINER_USER ?= "0:$(shell id -g)"

.PHONY: docker-build docker-test run-test cleanup-test test

all: docker-build docker-test

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--tag $(IMAGE_TAG) \
		--pull

docker-test:
	TEST_ADDR="${TEST_ADDR}" ./test.sh

test: run-test test cleanup-test

run-test:
	TEST_ADDR="${TEST_ADDR}" \
	CONTAINER_USER="${CONTAINER_USER}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	docker-compose -f docker-compose-latest.test.yml up -d
	# --exit-code-from=sut --abort-on-container-exit
	@echo "You can browse: http://${TEST_ADDR}"
	@sleep 2
	docker exec test-bench sh -eu /test.sh

cleanup-test:
	@echo "Stopping and removing the container"
	TEST_ADDR="${TEST_ADDR}" \
	CONTAINER_USER="${CONTAINER_USER}" \
	IMAGE_TAG="${IMAGE_TAG}" \
	docker-compose -f docker-compose-latest.test.yml down
