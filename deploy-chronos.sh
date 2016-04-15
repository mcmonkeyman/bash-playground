#!/bin/bash

# Check that chrons credentials are set
echo ${CHRONOS_USER}:?"Need to set CHRONOS_USER to non-empty value"}
echo ${CHRONOS_PASS}:?"Need to set CHRONOS_PASS to non-empty value"}

# Check that the tags are set
echo ${ACRIS_TAG:?"Need to set ACRIS_TAG non-empty"}
echo ${EMAIL_BUGGER_TAG:?"Need to set EMAIL_BUGGER_TAG non-empty"}
echo ${ENQUEUE_TAG:?"Need to set ENQUEUE_TAG non-empty"}
echo ${ES_TAG:?"Need to set ES_TAG non-empty"}
echo ${HPD_TAG:?"Need to set HPD_TAG non-empty"}
echo ${ST_TAG:?"Need to set ST_TAG non-empty"}

# Check for env
if [ $# -ne 1 ]; then
  echo "Missing env."
  echo "Usage:./deploy-chronos.sh dev|prd"
  exit 1
fi

ENV=$1

# Chronos settings
CHRONOS_URL="http://chronos.$ENV.reonomy.com"

function put_to_chronos {
  REPO_NAME=${1}
  REPO_TAG=${2}

  # iso860
  for job in $(ls ${REPO_NAME}/iso8601); do
    JOB_JSON=$(sed "s/TAG/${REPO_TAG}/g" ${REPO_NAME}/iso8601/${job})
    echo ${job}
    curl -v -X PUT -H "Content-Type:application/json" -d "${JOB_JSON}" -u ${CHRONOS_USER}:${CHRONOS_PASS} ${CHRONOS_URL}/scheduler/iso8601
  done

  # dependency
  for job in $(ls ${REPO_NAME}/dependency); do
    JOB_JSON=$(sed "s/TAG/${REPO_TAG}/g" ${REPO_NAME}/dependency/${job})
    echo ${job}
    curl -v -X PUT -H "Content-Type:application/json" -d "${JOB_JSON}" -u ${CHRONOS_USER}:${CHRONOS_PASS} ${CHRONOS_URL}/scheduler/dependency
  done
}

function put_acris {
  put_to_chronos 'acris' ${ACRIS_TAG}
}

function put_email_bugger {
  put_to_chronos 'email-bugger' ${EMAIL_BUGGER_TAG}
}

function put_enqueue {
  put_to_chronos 'enqueue' ${ENQUEUE_TAG}
}

function put_hpd {
  put_to_chronos 'hpd' ${HPD_TAG}
}

function put_es_loaders {
  put_to_chronos 'es-loaders' ${ES_TAG}
}

function put_scheduled_tasks {
  put_to_chronos 'scheduled-tasks' ${ST_TAG}
}

function put_all_jobs_to_chronos {
  put_acris && put_email_bugger && put_enqueue && put_hpd && put_es_loaders && put_scheduled_tasks
}

PS3='Please enter your choice: '

option1='All'
option2='Acris'
option3='Email-Bugger'
option4='Enqueue'
option5='Hpd'
option6='Es-Loaders'
option7='Scheduled-Tasks'

selectoptions=($option1 $option2 $option3 $option4 $option5 $option6 $option7 "Quit")
select opt in "${selectoptions[@]}"
do
    case $opt in
        $option1)
            echo $option1
            put_all_jobs_to_chronos
            break
            ;;
        $option2)
            echo $option2
            put_acris
            break
            ;;
        $option3)
            echo $option3
            put_email_bugger
            break
            ;;
        $option4)
            echo $option4
            put_enqueue
            break
            ;;
        $option5)
            echo $option5
            put_hpd
            break
            ;;
        $option6)
            echo $option6
            put_es_loaders
            break
            ;;
        $option7)
            echo $option7
            put_scheduled_tasks
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
