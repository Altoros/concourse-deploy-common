#!/usr/bin/env bash
set -ex

project_dir=$(readlink -f "$(dirname $0)/../..")
source $project_dir/ci/utils/load-bosh-env.sh

bosh run-errand $ERRAND
