#!/usr/bin/env bash
#
# Run any noodoo task
# The task will be run in subshell to keep current working dir unchanged

set -eo pipefail

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CWD}/../lib/lib.sh"

load_config "$@"

log "running ${CMD}..."

(cd "${ND_PATH}"; NODE_ENV="${ND_ENV}" ${CMD})

log::ok "$0 finished!"