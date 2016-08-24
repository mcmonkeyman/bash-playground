#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Missing filenams"
  echo "Usage:./compare-chronos-backups.sh file1 file2"
  exit 1
fi


LOG_DIR=./run-logs/
TIME_STAMP=$(date +%Y-%m-%d-%T)
RUN_DIR=$LOG_DIR/$TIME_STAMP
mkdir -p $RUN_DIR

FILE_ONE=$RUN_DIR/sorted_${1##*/}
FILE_TWO=$RUN_DIR/sorted_${2##*/}
DIFF=$RUN_DIR/diff

jq 'sort | .[] ' $1 > $FILE_ONE
jq 'sort | .[] ' $2 > $FILE_TWO
diff $FILE_ONE $FILE_TWO > $DIFF

cat $DIFF

