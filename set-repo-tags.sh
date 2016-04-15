#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Missing repo directory."
  echo "Usage:./set-repo-tags.sh /directory/with/repos"
  exit 1
fi

REPOS_PATH=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ACRIS_REPO_PATH=${REPOS_PATH}'/acris/';
ACRIS_TAG_ENV='ACRIS_TAG';

EMAIL_BUGGER_REPO_PATH=${REPOS_PATH}'/email-bugger/';
EMAIL_BUGGER_TAG_ENV='EMAIL_BUGGER_TAG';

ENQUEUE_REPO_PATH=${REPOS_PATH}'/enqueue/';
ENQUEUE_TAG_ENV='ENQUEUE_TAG';

ES_LOADERS_REPO_PATH=${REPOS_PATH}'/es-loaders/';
ES_LOADERS_TAG_ENV='ES_TAG';

HDP_REPO_PATH=${REPOS_PATH}'/hpd/';
HPD_TAG_ENV='HPD_TAG';

ST_REPO_PATH=${REPOS_PATH}'/scheduled-tasks/'
ST_TAG_ENV='ST_TAG'

function set_latest_tag {
  tagName=${1};
  repoPath=${2};
  cd ${repoPath};
  git fetch --tags;
  latestTag=$(git describe --tags `git rev-list --tags --max-count=1`);
  export ${tagName}=${latestTag};
  return 0
}

function clear_env {
  unset ${ACRIS_TAG_ENV}
  unset ${EMAIL_BUGGER_TAG_ENV}
  unset ${ENQUEUE_TAG_ENV}
  unset ${ES_LOADERS_TAG_ENV}
  unset ${HPD_TAG_ENV}
  unset ${ST_TAG_ENV}
}

function set_env {
  set_latest_tag ${ACRIS_TAG_ENV} ${ACRIS_REPO_PATH}
  set_latest_tag ${EMAIL_BUGGER_TAG_ENV} ${EMAIL_BUGGER_REPO_PATH}
  set_latest_tag ${ENQUEUE_TAG_ENV} ${ENQUEUE_REPO_PATH}
  set_latest_tag ${ES_LOADERS_TAG_ENV} ${ES_LOADERS_REPO_PATH}
  set_latest_tag ${ST_TAG_ENV} ${ST_REPO_PATH}
  set_latest_tag ${HPD_TAG_ENV} ${HDP_REPO_PATH}
}

function print_env {
  SEPERATOR="--------------------"
  echo "${SEPERATOR}"
  env | grep TAG
  echo "${SEPERATOR}"
}

clear_env && set_env && print_env
# Return to scipt dir
cd ${DIR}
