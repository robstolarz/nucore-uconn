#!/bin/bash

# let's print everything to the console
set -x
# blow up if any part of this stops working
set -e
# TODO: set up proper logging by directing logging to stdout

source ./docker/setup.sh
if [ "$RAILS_ENV" != "development" ]; then
  bundle exec rake assets:precompile
fi
wait-for-it "${SETUP_HOST}:8000" -t 0

### run nucore
## app server
bundle exec rails s -p 3000 -b '0.0.0.0' -e $RAILS_ENV
