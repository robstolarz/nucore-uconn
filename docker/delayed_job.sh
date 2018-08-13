#!/bin/bash

set -x
source ./docker/setup.sh
wait-for-it "${SETUP_HOST}:8000" -t 0
./script/delayed_job run
