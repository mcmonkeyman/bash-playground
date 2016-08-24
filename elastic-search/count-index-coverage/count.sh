#!/bin/sh

LOG_DIR=./run-logs/
TIME_STAMP=$(date +%Y-%m-%d-%T)
RUN_DIR=${LOG_DIR}/${TIME_STAMP}
mkdir -p "$RUN_DIR"

OUTPUT=$RUN_DIR/out-dev-full.txt

echo 'Total'
cat $OUTPUT | grep -v '^$' | wc -l

echo 'Total hits'
cat $OUTPUT | grep -v '^$' | jq '.hits.hits | length > 0' | grep 'true' | wc -l

echo 'Total misses'
cat $OUTPUT | grep -v '^$' | jq '.hits.hits | length <= 0' | grep 'true' | wc -l
