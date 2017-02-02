#!/bin/bash -e

project_dir=$(readlink -f "$(dirname $0)/../../..")
source $project_dir/ci/utils/load-bosh-env.sh

chmod +x omg-cli/omg-linux

omg-cli/omg-linux deploy-product \
  --bosh-url  $BOSH_URL \
  --bosh-user $BOSH_USERNAME \
  --bosh-pass $BOSH_PASSWORD \
  --print-manifest \
  --ssl-ignore \
  $PRODUCT_PLUGIN \
  $HAPROXY_FLAG \
  --infer-from-cloud \
  --stemcell-version $STEMCELL_VERSION \
  --system-domain $SYSTEM_DOMAIN \
  --vault-active \
  --vault-domain $VAULT_ADDR \
  --vault-hash-host $VAULT_HASH_HOSTVARS \
  --vault-hash-ip $VAULT_HASH_IP \
  --vault-hash-keycert $VAULT_HASH_KEYCERT \
  --vault-hash-misc $VAULT_HASH_MISC \
  --vault-hash-password $VAULT_HASH_PASSWORD \
  --vault-rotate \
  --vault-token $VAULT_TOKEN > throw-away-manifest.yml

#eof
