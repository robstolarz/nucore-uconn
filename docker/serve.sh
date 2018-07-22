#!/bin/bash

# let's print everything to the console
set -x
# blow up if any part of this stops working
set -e
# TODO: set up proper logging by directing logging to stdout

./docker/setup.sh
wait-for-it "${MYSQL_HOST}:3306" -t 0
wait-for-it "${SETUP_HOST}:8000" -t 0

### run nucore
## jobs
./script/delayed_job start &
## app server
bundle exec rails s -p 3000 -b '0.0.0.0' -e development

wait
