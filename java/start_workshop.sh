#!/usr/bin/env bash

readonly SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd );
readonly ROOT_SCRIPT_DIR="${SCRIPT_DIR}/..";
readonly PROJECT_NAME="pictures-analyzer-java"
readonly PROJECT_DIR="${ROOT_SCRIPT_DIR}/${PROJECT_NAME}"
readonly GIT_REPOSITORY_URL="https://github.com/jcraftsman/${PROJECT_NAME}.git"
readonly DEFAULT_ITERATION_NUMBER=1

function main
{
  check_command_exists "git" "Git command line tool is not installed in your computer. You need to install it."
  check_command_exists "java" "Java is not installed in your computer. You need to install it."
  iteration_number=${1:-$DEFAULT_ITERATION_NUMBER}

  set -o errexit
  set -o pipefail
  set -o nounset
  set -o errtrace

  rm -rf .git

  setup_iteration ${iteration_number}

  echo ""
  echo ""
  echo "****************************************************************************************"
  echo ""
  echo "You're all set! Have fun with 'Real world Evolutionary Design with Java' workshop! ;-)"
  echo ""
  echo "****************************************************************************************"
  echo ""
}

function check_command_exists
{
  command=$1
  message=$2
  command -v ${command} >/dev/null 2>&1 || { echo >&2 ${message}; exit 1; }
}

function setup_iteration
{
  iteration_number=$1
  if [ -d ${PROJECT_DIR} ]; 
  then
    cd ${PROJECT_DIR}
    take_care_of_ongoing_changes
  else
    git clone ${GIT_REPOSITORY_URL}
    cd ${PROJECT_DIR}
  fi
  git checkout "workshop-it${iteration_number}"
  ./gradlew clean
}

function take_care_of_ongoing_changes
{
  if git diff-index --quiet HEAD --; 
  then
    git status
  else
    echo ""
    echo "/!\ You have some unstaged changes. /!\ "
    echo "We will take care of adding your changes to the branch: `git rev-parse --abbrev-ref HEAD`"
    git add .
    git commit -m "work in progress (automatic commit)"
    echo ""
  fi
}

main "$@"
