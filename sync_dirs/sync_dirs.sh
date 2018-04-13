#!/usr/bin/env bash
#
# Sync remote directories

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CWD}/../lib/lib.sh"

load_config "$@"

main() {
  log::ok "$0 starting"

  local i src dst
  for i in {1..20}; do
    # bash it, baby!
    eval src="\$SRC_DIR$i"
    eval dst="\$DST_DIR$i"

    [[ ! -z "${src// }" ]] && clone "${src}" "${dst}"
  done

  log::ok "$0 finished!"
}

clone() {
  local src="$1"
  local dst="$2"

  local ssh_key=""
  [ ! -z "${SSH_KEY}" ] && ssh_key="-i ${SSH_KEY}"

  local rsync_opts='-rlOhv'
  [ ! -z "${RSYNC_OPTS}" ] && rsync_opts="${RSYNC_OPTS}"

  local reset_cmd="echo 'DST_USER not set, skipping dir reset'"
  [ ! -z "${DST_USER}" ] && reset_cmd="sudo chmod -R g+w '${dst}' && sudo chown -R '${DST_USER}:${DST_USER}' '${dst}'"

  local clone_cmd
  case "${CLONE_TYPE}" in
    "rsync")
      clone_cmd="rsync ${rsync_opts} -O -e 'ssh ${ssh_key}' '${SRC_USER}@${SRC_HOST}':'${src}' '${dst}'"
    ;;
    "scp")
      clone_cmd="scp -r -i '${SSH_KEY}' '${SRC_USER}@${SRC_HOST}':'${src}' '${dst}'"
    ;;
    "*")
      exception "unknown CLONE_TYPE type ${CLONE_TYPE}"
    ;;
  esac

  [ ! -z "${TIMEOUT}" ] && clone_cmd="timeout ${TIMEOUT} ${clone_cmd}"

  log "cloning ${SRC_HOST}:${src} to ${dst}"
  [ ! -z "${VERBOSE}" ] && log "${reset_cmd}"
  eval "${reset_cmd}"
  [ ! -z "${VERBOSE}" ] && log "${clone_cmd}"
  eval "${clone_cmd}"
  [ ! -z "${VERBOSE}" ] && log "${reset_cmd}"
  eval "${reset_cmd}"

  log::info "${SRC_HOST}:${src} is downloaded"
}

main "$@"
