#!/usr/bin/env bash
#
# Run any command on redis master server on specified DB

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CWD}/../lib/lib.sh"

load_config "$@"

main() {
  local master_ip

  log::info "starting redis task '${REDIS_CMD}' for ${REDIS_SERVERS}/${REDIS_DB}..."

  get_master_ip
  log "redis found master ip: ->${master_ip}<-"

  run="redis-cli -h ${master_ip} -n ${REDIS_DB} ${REDIS_CMD}"

  log::info "${run}"

  eval "${run}"

  log::ok "$0 finished!"
}

get_master_ip() {
  local ip

  master_ip="${REDIS_SERVERS[0]}"

  for srv in "${REDIS_SERVERS[@]}"; do
    # ip="$(redis-cli -h ${srv} info | grep master_host | sed 's/^.*://' | tr -d '[:space:]')"
    ip=$(redis-cli -h ${srv} info | grep master_host | cut -f2 -d':' | tr -d '[:space:]')

    [ ! -z "$ip" ] && master_ip="$ip"
  done
}

main "$@"
