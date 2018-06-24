#!/bin/bash

# let's print everything to the console
set -x
# TODO: set up proper logging by directing logging to stdout

./docker/setup.sh
wait-for-it db:3306 -t 0
wait-for-it setup:8000 -t 0

### run nucore
## jobs
./script/delayed_job start &
## app server
bundle exec rails s -p 3000 -b '0.0.0.0' -e development

wait
