#!/usr/bin/env bash
set -e

project_dir=$(readlink -f "$(dirname $0)/../..")
source $project_dir/ci/utils/load-bosh-env.sh

VAULT_PATH_PROPS=secret/$PRODUCT_NAME-$FOUNDATION_NAME-props
MASTER_IP=$(vault read --field=master-ip $VAULT_HASH_PROPS)
SLAVE_IP=$(vault read --field=slave-ip $VAULT_HASH_PROPS)
REDIS_PASSWORD=$(vault read --field=redis-pass $VAULT_HASH_PROPS)
NETWORK_NAME=$(vault read --field=network-name $VAULT_HASH_PROPS)
VM_SIZE=$(vault read --field=vm-type $VAULT_HASH_PROPS)

$(vault read --format=json $VAULT_PATH_PROPS)

SLAVE_INSTANCES=$(($(grep -o "," <<< "$SLAVE_IP" | wc -l)+1))
MASTER_INSTANCES=$(($(grep -o "," <<< "$MASTER_IP" | wc -l)+1))
POOL_INSTANCES=$((MASTER_INSTANCES + SLAVE_INSTANCES))

bosh interpolate $project_dir/manifest/base.yml \
             --vars-file manifest/props.yml \
             --vars-file manifest/ips.yml \
             --vars-file manifest/passwords.yml \
             --vars-store manifest/vars.yml \
             --var="deployment-name=$BOSH_DEPLOYMENT" \
             --var-errs --var-errs-unused > manifest/deployment.yml

bosh deploy manifest/deployment.yml

#eof
