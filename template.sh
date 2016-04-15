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
