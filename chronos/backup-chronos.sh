#!/bin/bash
# requires jsonpp to be installed

: ${CHRONOS_USER:?"Need to set CHRONOS_USER to non-empty value"}
: ${CHRONOS_PASS:?"Need to set CHRONOS_PASS to non-empty value"}

if [ $# -ne 1 ]; then
  echo "Missing env."
  echo "Usage:./backup-chronos.sh dev|prd"
  exit 1
fi

ENV=$1

LOG_DIR=./run-logs/
TIME_STAMP=$(date +%Y-%m-%d-%T)
RUN_DIR=$LOG_DIR/$TIME_STAMP
mkdir -p $RUN_DIR

function timestamp {
  return date +"%T"
}

CHRONOS_URL="http://chronos.$ENV.reonomy.com"

BACKUP_FILE=${RUN_DIR}${ENV}_backup_$(date +%Y-%m-%d--%H%M%S).json

curl -v  -H "Content-Type:application/json"  -u $CHRONOS_USER:$CHRONOS_PASS $CHRONOS_URL/scheduler/jobs | jsonpp > ${BACKUP_FILE} 

echo BACKUP_FILE
