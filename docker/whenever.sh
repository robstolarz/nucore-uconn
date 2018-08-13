#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run me as root!"
  exit 1
fi
set -x
source ./docker/setup.sh

# cancel the script if things fail
set -e

# TODO: decide whether to remove env setter in config/schedule.rb
bundle exec whenever --update-crontab --set environment=$RAILS_ENV
wait-for-it "${SETUP_HOST}:8000" -t 0
cron -f # -f meaning "foreground"
