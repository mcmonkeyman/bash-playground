#!/bin/sh
FILE=$1
NAME=`echo "$FILE" | cut -d'.' -f1`

jq '.[] | .name, .schedule' ${FILE} |  sed '$!N;s/\n/ /' | sort > ./summary_${NAME}_$(date +%Y-%m-%d--%H%M%S).txt;

