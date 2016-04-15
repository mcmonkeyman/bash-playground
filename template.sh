#!/bin/bash
# Boiler plate bash script

# Check that the environmental varibles  are set
echo ${ENV_VAR}:?"Need to set ENV_VAR to non-empty value"}

# Check for flags
if [ $# -ne 1 ]; then
  echo "Missing flag."
  echo "Usage:./template.sh flag"
  exit 1
fi

