#!/usr/bin/env bash
#
# Run mysql script at database

set -eo pipefail

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CWD}/../lib/lib.sh"

load_config "$@"

db_login="-h${DB_HOST} -u${DB_USER} ${DB_NAME}"

if [ ! -z "$DB_TASK" ]; then
  log::info mysql $db_login -e \"${DB_TASK}\"
  mysql ${db_login} "-p${DB_PWD}" -v -e "${DB_TASK}"
fi
