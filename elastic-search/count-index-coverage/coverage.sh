#!/bin/sh

: ${PGHOST:?"Need to set PGHOST to non-empty value"}
: ${PGPASSWORD:?"Need to set PGPASSWORD to non-empty value"}
: ${PGPORT:?"Need to set PGPORT to non-empty value"}
: ${PGUSER:?"Need to set PGUSER to non-empty value"}

: ${ES_HOST:?"Need to set ES_HOST to non-empty value"}
: ${ES_USERNAME:?"Need to set ES_USERNAME to non-empty value"}
: ${ES_PASSWORD:?"Need to set ES_PASSWORD to non-empty value"}


LOG_DIR=./run-logs/
TIME_STAMP=$(date +%Y-%m-%d-%T)
RUN_DIR=${LOG_DIR}/${TIME_STAMP}
mkdir -p "$RUN_DIR"

INPUT=$LOG_DIR/in.txt
OUTPUT=$LOG_DIR/out.txt
INDEX_NAME='nyc-parceldetails-20160816112919691'

psql -t -f ./get-all-ids.sql > $INPUT

for id in $(cat "$INPUT")
do
    id_no_spaces=`echo $id | xargs`
    echo $ES_USERNAME
    echo '{"query" : {"constant_score" : {"filter" : {"term" : {"legacy_id" : "'$id_no_spaces'" } } } } }' | \
        curl -XPOST  -d @- -u ${ES_USERNAME}:${ES_PASSWORD} http://${ES_HOST}/${INDEX_NAME}/_search >> ${OUTPUT}
    echo "\n" >> ${OUTPUT}
done


