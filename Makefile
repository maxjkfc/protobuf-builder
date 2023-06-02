PROJECT_BASE_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
.PHONY: build
build:
	@echo build ${PROJECT_BASE_DIR}/${target}

	@cd ${target} && \
	protoc \
	-I=. \
	--go_out=paths=source_relative:. \
	--go-grpc_out=paths=source_relative,require_unimplemented_servers=false:. \
	--fastmarshal_out=paths=source_relative,apiversion=v2,filepermessage=true:. *.proto 

.PHONY: install
install:
	@echo install tools
	brew update && brew install protobuf
	go get -u google.golang.org/protobuf/proto
	go get -u github.com/protocolbuffers/protobuf
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/CrowdStrike/csproto/cmd/protoc-gen-fastmarshal@latest


## help: help range
.PHONY: help
help:
	@echo "Useage:\n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

