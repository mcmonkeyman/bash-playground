#!/bin/bash
# requires jsonpp to be installed

function timestamp {
  return date +"%T"
}

CHRONOS_URL="http://chronos.dev.reonomy.com"
CHRONOS_USER=
CHRONOS_PASS=

BACKUP_DIR="./backup/"
mkdir -p ${BACKUP_DIR}
BACKUP_FILE=${BACKUP_DIR}dev_backup_$(date +%Y-%m-%d--%H%M%S).json

curl -v  -H "Content-Type:application/json"  -u $CHRONOS_USER:$CHRONOS_PASS $CHRONOS_URL/scheduler/jobs | jsonpp > ${BACKUP_FILE} 
