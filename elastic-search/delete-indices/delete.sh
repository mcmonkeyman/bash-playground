
: ${ES_HOST:?"Need to set ES_HOST to non-empty value"}
: ${ES_USERNAME:?"Need to set ES_USERNAME to non-empty value"}
: ${ES_PASSWORD:?"Need to set ES_PASSWORD to non-empty value"}

LOG_DIR=./run-logs/
TIME_STAMP=$(date +%Y-%m-%d-%T)
RUN_DIR=${LOG_DIR}/${TIME_STAMP}
mkdir -p "$RUN_DIR"

ALIAS_BEFORE=$RUN_DIR/${ES_HOST}_alias_before.txt
ALIAS_AFTER=$RUN_DIR/${ES_HOST}_alias_after.txt
INDEX_BEFORE=$RUN_DIR/${ES_HOST}_index_before.txt
INDEX_AFTER=$RUN_DIR/${ES_HOST}_index_after.txt

rm -rf ALIAS_BEFORE
rm -rf ALIAS_AFTER
rm -rf INDEX_BEFORE
rm -rf INDEX_AFTER

# Log the aliases and indices before
curl  -u reonomist:${ES_PASSWORD} http://${ES_HOST}/_cat/aliases?v > $ALIAS_BEFORE 
curl  -u reonomist:${ES_PASSWORD} http://${ES_HOST}/_cat/indices?v > $INDEX_BEFORE

# Delete the aliases and indices
curl -XDELETE -u reonomist:${ES_PASSWORD} http://${ES_HOST}/geo-*?v
curl -XDELETE -u reonomist:${ES_PASSWORD} http://${ES_HOST}/wellspring-*?v
curl -XDELETE -u reonomist:${ES_PASSWORD} http://${ES_HOST}/la-address-*?v

# Log the aliases and indices after
curl  -u reonomist:${ES_PASSWORD} http://${ES_HOST}/_cat/aliases?v > $ALIAS_AFTER
curl  -u reonomist:${ES_PASSWORD} http://${ES_HOST}/_cat/indices?v > $INDEX_AFTER


echo 'ALIAS DIFF ....... '
bash -c "diff <(sort $ALIAS_BEFORE)  <(sort $ALIAS_AFTER)"

echo 'INDEX DIFF ....... '
bash -c "diff <(sort $INDEX_BEFORE) <(sort $INDEX_AFTER)"
