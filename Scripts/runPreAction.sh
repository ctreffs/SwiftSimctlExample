#!/bin/bash

# cleaning up hanging servers
killall SimctlCLI 

# fail fast
set -e

${SRCROOT}/Scripts/SimctlCLI start-server > /dev/null 2>&1 &
