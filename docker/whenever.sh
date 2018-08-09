#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run me as root!"
  exit 1
fi
set -x
./docker/setup.sh
# TODO: decide whether to remove env setter in config/schedule.rb
RAILS_ENV=development bundle exec whenever --update-crontab --set environment=development
wait-for-it "${SETUP_HOST}:8000" -t 0
cron -f # -f meaning "foreground"
