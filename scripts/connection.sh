#!/bin/bash

export MARIADB_SERVER_HOST="wasp-telemetry.mariadb.database.azure.com"
export MARIADB_SERVER_PORT="3306"
export MARIADB_SERVER_ADMIN_USERNAME="${USER}"
export MARIADB_DATABASE_NAME="metrics"

source password.conf

echo "MARIADB_SERVER_HOST...........: ${MARIADB_SERVER_HOST}"
echo "MARIADB_SERVER_ADMIN_USERNAME.: ${MARIADB_SERVER_ADMIN_USERNAME}"
echo "MARIADB_SERVER_ADMIN_PASSWORD.: ${MARIADB_SERVER_ADMIN_PASSWORD:0:3}"
echo "MARIADB_DATABASE_NAME.........: ${MARIADB_DATABASE_NAME}"
echo ""

# mysql \
#   --ssl \
#   --host "${MARIADB_SERVER_HOST?}" \
#   --user "${MARIADB_SERVER_ADMIN_USERNAME?}" \
#   --password="${MARIADB_SERVER_ADMIN_PASSWORD?}" \
#   ${MARIADB_DATABASE_NAME?} < commands.sql

mysql \
  --ssl \
  --host "${MARIADB_SERVER_HOST?}" \
  --user "${MARIADB_SERVER_ADMIN_USERNAME?}" \
  --password="${MARIADB_SERVER_ADMIN_PASSWORD?}"
  
mysql \
  --ssl \
  --host "${MARIADB_SERVER_HOST?}" \
  --user "${MARIADB_SERVER_ADMIN_USERNAME?}" \
  --password="${MARIADB_SERVER_ADMIN_PASSWORD?}" < "use metrics;"
