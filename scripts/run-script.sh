#!/usr/bin/env bash
set -e

if [[ -z $SCRIPT ]]; then
  echo "one the following environment variables is not set: "
  echo
  echo "                 SCRIPT"
  echo
fi

./pipeline-repo/$SCRIPT
