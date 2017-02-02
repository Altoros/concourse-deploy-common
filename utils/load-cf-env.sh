


echo "Loading Cloud Foundry environment"

if [[ -z $VAULT_ADDR || -z $VAULT_TOKEN || -z $FOUNDATION_NAME ]]; then
  echo "ERROR: one of the following environment variables is not set: "
  echo ""
  echo "                 VAULT_ADDR"
  echo "                 VAULT_TOKEN"
  echo "                 FOUNDATION_NAME"
  echo ""
  exit 1
fi

export VAULT_HASH_CF_PROPS="secret/cf-$FOUNDATION_NAME-props"
export VAULT_HASH_CF_PASSWORDS="secret/cf-$FOUNDATION_NAME-password"
export CF_SYSTEM_DOMAIN=$(vault read -field=system-domain $VAULT_HASH_CF_PROPS)
export CF_API_DOMAIN=https://api.$CF_SYSTEM_DOMAIN
export CF_APPS_DOMAIN=$(vault read -field=app-domain $VAULT_HASH_CF_PROPS)

export CF_ADMIN_USERNAME=admin
export CF_ADMIN_PASSWORD=$(vault read -field=admin-password $VAULT_HASH_CF_PASSWORDS)

export SYSLOG_AGGREGATOR_HOST=$(vault read -field=syslog-address $VAULT_HASH_CF_PROPS)
export SYSLOG_AGGREGATOR_PORT=514

export CF_NATS_IPS=$(vault read -field=nats-machine-ip $VAULT_HASH_CF_PROPS)
export CF_NATS_PORT=4222
export CF_NATS_USERNAME=nats
export CF_NATS_PASSWORD=$(vault read -field=nats-pass $VAULT_HASH_CF_PASSWORDS)

cf api $CF_API_DOMAIN --skip-ssl-validation
cf auth $CF_ADMIN_USERNAME $CF_ADMIN_PASSWORD
cf target -o system -s system
