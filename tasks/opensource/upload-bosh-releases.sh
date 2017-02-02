#!/usr/bin/env bash
set -e

project_dir=$(readlink -f "$(dirname $0)/../../..")
source $project_dir/ci/utils/load-bosh-env.sh


chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-product-bundle/$PRODUCT_PLUGIN

PRODUCT_NAME=$(printf $PRODUCT_PLUGIN | sed 's,-plugin.*,,')

meta=$(omg-cli/omg-linux product-meta $PRODUCT_NAME | grep 'release: ')


while read -r line; do
  release_url=$(echo $line | awk '{printf $2}')
  bosh upload-release $release_url
done <<< "$meta"

#eof
