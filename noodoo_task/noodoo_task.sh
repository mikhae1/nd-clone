#!/usr/bin/env bash
#
# Run any noodoo task
# The task will be run in subshell to keep current working dir unchanged

set -eo pipefail

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CWD}/../lib/lib.sh"

load_config "$@"

run="NODE_ENV=${ND_ENV} ${CMD}"

log::info "running ${run}..."

cd "${ND_PATH}" && eval "${run}"

log::ok "$0 finished!"
