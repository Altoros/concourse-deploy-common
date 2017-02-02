#!/usr/bin/env bash
set -e

project_dir=$(readlink -f "$(dirname $0)/../..")
source $project_dir/ci/utils/load-bosh-env.sh

VAULT_HASH_PROPS=secret/redis-$FOUNDATION_NAME-props
MASTER_IP=$(vault read --field=master-ip $VAULT_HASH_PROPS)
SLAVE_IP=$(vault read --field=slave-ip $VAULT_HASH_PROPS)
REDIS_PASSWORD=$(vault read --field=redis-pass $VAULT_HASH_PROPS)
NETWORK_NAME=$(vault read --field=network-name $VAULT_HASH_PROPS)
VM_SIZE=$(vault read --field=vm-type $VAULT_HASH_PROPS)

SLAVE_INSTANCES=$(($(grep -o "," <<< "$SLAVE_IP" | wc -l)+1))
MASTER_INSTANCES=$(($(grep -o "," <<< "$MASTER_IP" | wc -l)+1))
POOL_INSTANCES=$((MASTER_INSTANCES + SLAVE_INSTANCES))

# chmod +x omg-cli/omg-linux

# omg-cli/omg-linux register-plugin \
#   -type product \
#   -pluginpath omg-product-bundle/$PRODUCT_PLUGIN

# omg-cli/omg-linux deploy-product \
#   --bosh-url  $BOSH_URL \
#   --bosh-user $BOSH_USERNAME \
#   --bosh-pass $BOSH_PASSWORD \
#   --print-manifest \
#   --ssl-ignore \
#   $PRODUCT_PLUGIN \
#   --master-ip=$MASTER_IP \
#   --slave-ip=$SLAVE_IP \
#   --redis-pass=$REDIS_PASS \
#   --slave-instances=$SLAVE_INSTANCES \
#   --errand-instances=1 \
#   --pool-instances=$POOL_INSTANCES \
#   --network-name=$NETWORK_NAME \
#   --vm-type=$VM_SIZE \
#   --stemcell-url=https://bosh.io/d/stemcells/bosh-vsphere-esxi-ubuntu-trusty-go_agent?v=3263.17 \
#   --stemcell-ver=3263.17 \
#   --stemcell-sha=70ca4e0f8a3602a53919cd4e8fd97770ed7da234 > manifest/deployment.yml


bosh interpolate $project_dir/manifest/base.yml \
                 --vars-store secrets.yml \
                 --var="deployment-name=$DEPLOYMENT_NAME" \
                 --var="master-instances-count=$MASTER_INSTANCES" \
                 --var="network=$NETWORK_NAME" \
                 --var="redis-password=$REDIS_PASSWORD" \
                 --var="slave-ip=$SLAVE_IP" \
                 --var="vm-type=$VM_SIZE" \
                 --var-errs > manifest/deployment.yml

bosh deploy manifest/deployment.yml

#eof
