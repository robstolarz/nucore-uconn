#!/bin/bash

## secrets: if a secret was not given through k8s or docker, we generate one
NUCORE_SECRET="${NUCORE_SECRET:-$(rake secret)}"
sed "s/secret_key_base: .*/secret_key_base: ${NUCORE_SECRET}/g" \
	< config/secrets.yml.template > config/secrets.yml
cat config/secrets.yml

## database: we configure, setup, and migrate a DB
export MYSQL_USER="${MYSQL_USER:-root}"
export MYSQL_PASS="${MYSQL_PASS:-}" # set to a blank string
export MYSQL_HOST="${MYSQL_HOST:-localhost}"
cp config/database.yml.mysql.template config/database.yml
cat config/database.yml
# TODO: configure database names using yq or something

## configuring file storage
# TODO: provide file storage options
