#!/bin/bash
# Boiler plate bash script

# Check that the environmental varibles  are set
: ${ENV_VAR:?"Need to set ENV_VAR to non-empty value"}

# Check for flags
if [ $# -ne 1 ]; then
  echo "Missing flag."
  echo "Usage:./template.sh flag"
  exit 1
fi

FLAG=$1

LOG_DIR=./run-logs/
TIME_STAMP=$(date +%Y-%m-%d-%T)
RUN_DIR=$LOG_DIR/$TIME_STAMP
mkdir -p $RUN_DIR

SNAPSHOT_BEFORE=$RUN_DIR/snapshot_before.txt
SNAPSHOT_AFTER=$RUN_DIR/snapshot_after.txt

function function_one {
    echo "Function One"
}

function function_two {
    echo "Function Two"
}

PS3='Please enter your choice: '

option1="function_one"
option2="function_two"
option3="all"



selectoptions=($option1 $option2 $option3 "Quit")
select opt in "${selectoptions[@]}"
do
    case $opt in
        $option1)
            echo $option1
            function_one
            break
            ;;
        $option2)
            echo $option2
            function_two
            break
            ;;
        $option3)
            echo $option3
            function_one && function_two
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

echo 'before' > $SNAPSHOT_BEFORE
echo 'after' > $SNAPSHOT_AFTER

echo 'Diff between snapshost ....... '
bash -c "diff <(sort $SNAPSHOT_BEFORE)  <(sort $SNAPSHOT_AFTER)"
