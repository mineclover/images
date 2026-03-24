#!/bin/bash

set -e

go test -race -v -coverprofile=coverage.txt -covermode=atomic ./...

go install golang.org/x/vuln/cmd/govulncheck@latest
"$(go env GOPATH)"/bin/govulncheck ./...
