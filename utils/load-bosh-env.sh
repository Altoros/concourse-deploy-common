
echo "Loading BOSH environment"

if [[ -z $VAULT_ADDR || -z $VAULT_TOKEN || -z $FOUNDATION_NAME ]]; then
  echo "ERROR: one of the following environment variables is not set: "
  echo ""
  echo "                 VAULT_ADDR"
  echo "                 VAULT_TOKEN"
  echo "                 FOUNDATION_NAME"
  echo ""
  exit 1
fi

export VAULT_HASH_BOSH="secret/bosh-$FOUNDATION_NAME-props"
export VAULT_PATH_BOSH_PROPS="secret/bosh-$FOUNDATION_NAME-props"
export VAULT_PATH_BOSH_PASSWORDS="secret/bosh-$FOUNDATION_NAME-passwords"
export VAULT_PATH_BOSH_IPS="secret/bosh-$FOUNDATION_NAME-ips"

export BOSH_URL=$(vault read -field=bosh-url   $VAULT_HASH_BOSH)
export BOSH_ENVIRONMENT=$BOSH_URL
export BOSH_USERNAME=$(vault read -field=bosh-user $VAULT_HASH_BOSH)
export BOSH_PASSWORD=$(vault read -field=bosh-pass $VAULT_HASH_BOSH)
export BOSH_CLIENT=$(vault read -field=bosh-client-id $VAULT_HASH_BOSH)
export BOSH_CA_CERT=$(vault read -field=bosh-cacert $VAULT_HASH_BOSH)
export BOSH_CLIENT_SECRET=$(vault read -field=bosh-client-secret $VAULT_HASH_BOSH)

export BOSH_DEPLOYMENT=$PRODUCT_NAME-$FOUNDATION_NAME
