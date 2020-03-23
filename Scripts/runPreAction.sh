#!/bin/bash

# cleaning up hanging servers
killall SimctlCLI

# fail fast
set -e

# start the server non-blocking from the checked out package
${BUILD_ROOT}/../../SourcePackages/checkouts/SwiftSimctl/bin/SimctlCLI start-server > /dev/null 2>&1 &
