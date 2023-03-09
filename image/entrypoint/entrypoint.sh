#!/bin/bash

# This function will be called when the container receives the TERM signal before its terminated.
function ExitContainer {
  echo Stopping container

  nginx -s stop
  PID_FILE=/tmp/web.pid && [ -f ${PID_FILE} ] && kill -9 `cat ${PID_FILE}`
  PID_FILE=/tmp/api.pid && [ -f ${PID_FILE} ] && kill -9 `cat ${PID_FILE}`

  # Last thing to call, add cleanup above this.
  exit 0
}

# Create directory if it doesn't exist, it can also set owner, group and permissions
function CreateDir {
  DIRECTORY_PATH=$1
  OWNER_GROUP=$2
  PERMISSIONS=$3

  if [ ! -d ${DIRECTORY_PATH} ]; then
    mkdir -p ${DIRECTORY_PATH}

    if [ ! "${OWNER_GROUP}" = "" ]; then
      chown ${OWNER_GROUP} ${DIRECTORY_PATH}
    fi
  
    if [ ! "${PERMISSIONS}" = "" ]; then
      chmod ${PERMISSIONS} ${DIRECTORY_PATH}
    fi
  fi
}

# Exports functions
export -f CreateDir

# Define handlers for system traps:
# - TERM or SIGTEM for a clean exit
trap ExitContainer SIGTERM

find /tmp -type f -name "*.pid" -maxdepth 1 -exec rm {} +

# Run application initialization scripts
DIR=/opt/entrypoint/entrypoint.d
if [ -d "$DIR" ]; then
  /bin/run-parts "$DIR"
fi

# If the container is invoked with a command (CMD), then execute the command
# otherwise loop until the container is terminated
if [ "$#" -gt 0 ]; then
  # The container was started with a CMD
  exec "$@"
else
  # Loop forever until terminated
  tail -f /dev/null & wait ${!}
fi
