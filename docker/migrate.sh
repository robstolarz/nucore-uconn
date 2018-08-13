#!/bin/bash

# let's print everything to the console
set -x

source ./docker/setup.sh

# try migrating the db if it exists, load schema otherwise
if rake db:migrate:status &> /dev/null; then
	rake db:environment:set RAILS_ENV=$RAILS_ENV
	rake db:migrate
else
	rake db:create
	rake db:environment:set RAILS_ENV=$RAILS_ENV
	rake db:schema:load
fi

## demo data: should we add demo stuff to the DB?
if [ ! -z ${DEMO_DATA+x} ]; then rake demo:seed; fi

# let anyone curious know we're ready
while true; do nc -lkp 8000; done
