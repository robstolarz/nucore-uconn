#!/bin/bash

## env
export RAILS_ENV="${RAILS_ENV:-production}" # it helps

## secrets: if secrets were not given through k8s or docker, we let rails generate them
NUCORE_SECRET="${NUCORE_SECRET:-<%= SecureRandom.hex %>}"
API_AUTH_NAME="${API_AUTH_NAME:-<%= SecureRandom.hex %>}"
API_AUTH_PASSWORD="${API_AUTH_PASSWORD:-<%= SecureRandom.hex %>}"
SECURE_ROOMS_AUTH_NAME="${SECURE_ROOMS_AUTH_NAME:-<%= SecureRandom.hex %>}"
SECURE_ROOMS_AUTH_PASSWORD="${SECURE_ROOMS_AUTH_PASSWORD:-<%= SecureRandom.hex %>}"
cat > config/secrets.yml << EOF
${RAILS_ENV}:
  secret_key_base: ${NUCORE_SECRET}
  api:
    basic_auth_name: ${API_AUTH_NAME}
    basic_auth_password: ${API_AUTH_PASSWORD}
  secure_rooms_api:
    basic_auth_name: ${SECURE_ROOMS_AUTH_NAME}
    basic_auth_password: ${SECURE_ROOMS_AUTH_PASSWORD}
EOF

## database: we configure, setup, and migrate a DB
export MYSQL_USER="${MYSQL_USER:-root}"
export MYSQL_PASS="${MYSQL_PASS:-}" # set to a blank string
export MYSQL_PASSWORD="${MYSQL_PASSWORD:-${MYSQL_PASS}}" # TODO: this is bad.
export MYSQL_HOST="${MYSQL_HOST:-localhost}"
cat config/database.yml.mysql.template > config/database.yml
cat config/database.yml.mysql.production.template >> config/database.yml
# TODO: configure database names using yq or something

## configuring file storage
# TODO: provide file storage options

# wait for db
wait-for-it "${MYSQL_HOST}:3306" -t 0
