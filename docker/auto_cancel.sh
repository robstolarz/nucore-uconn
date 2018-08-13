#!/bin/bash

set -x
source ./docker/setup.sh
wait-for-it "${SETUP_HOST}:8000" -t 0
bundle exec ruby lib/daemons/auto_cancel.rb run -- --no-monitor
