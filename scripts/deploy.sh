#!/usr/bin/env bash
set -e

### Load env

project_dir=$(readlink -f "$(dirname $0)/../..")
source $project_dir/ci/utils/load-bosh-env.sh
source $project_dir/ci/utils/load-cf-env.sh

VAULT_HASH_PROPS=secret/redis-$FOUNDATION_NAME-props
BROKER_IP=$(vault read --field=broker-ip $VAULT_HASH_PROPS)
DEDICATED_NODES_IPS=$(vault read --field=dedicated-nodes-ips $VAULT_HASH_PROPS)
NETWORK_NAME=$(vault read --field=network-name $VAULT_HASH_PROPS)
VM_TYPE=$(vault read --field=vm-type $VAULT_HASH_PROPS)
DISK_TYPE=$(vault read --field=disk-type $VAULT_HASH_PROPS)
AZ=$(vault read --field=az $VAULT_HASH_PROPS)

DEDICATED_NODES_COUNT=$(($(grep -o "," <<< "$DEDICATED_NODES_IPS" | wc -l)+1))

# ### Upload Releases

# bosh upload-release https://bosh.io/d/github.com/pivotal-cf/cf-redis-release?v=428.0.0
# bosh upload-release https://bosh.io/d/github.com/cloudfoundry-incubator/cf-routing-release?v=0.143.0

### Generate manifest
mkdir -p manifest

bosh interpolate $project_dir/manifest/base.yml \
             --vars-store manifest/vars.yml \
             --var="deployment-name=$BOSH_DEPLOYMENT" \
             --var="network-name=$NETWORK_NAME" \
             --var="vm-type=$VM_TYPE" \
             --var="disk-type=$DISK_TYPE" \
             --var="broker-ip=$BROKER_IP" \
             --var="cf-admin-username=$CF_ADMIN_USERNAME" \
             --var="cf-admin-password=$CF_ADMIN_PASSWORD" \
             --var="cf-apps-domain=$CF_APPS_DOMAIN" \
             --var="cf-system-domain=$CF_SYSTEM_DOMAIN" \
             --var="dedicated-nodes-count=$DEDICATED_NODES_COUNT" \
             --var="dedicated-nodes-ips=[$DEDICATED_NODES_IPS]" \
             --var="nats-ips=[$CF_NATS_IPS]" \
             --var="nats-port=$CF_NATS_PORT" \
             --var="nats-username=$CF_NATS_USERNAME" \
             --var="nats-password=$CF_NATS_PASSWORD" \
             --var="network-name=$NETWORK_NAME" \
             --var="syslog-aggregator-host=$SYSLOG_AGGREGATOR_HOST" \
             --var="syslog-aggregator-port=$SYSLOG_AGGREGATOR_PORT" \
             --var="az=$AZ" \
             --var-errs --var-errs-unused > manifest/deployment.yml

### Deploy

bosh -n deploy manifest/deployment.yml

#eof
