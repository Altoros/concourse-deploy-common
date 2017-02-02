echo "Loading Vault environment"

if [[ -z $VAULT_ADDR || -z $VAULT_TOKEN || -z $FOUNDATION_NAME ]]; then
  echo "ERROR: one of the following environment variables is not set: "
  echo ""
  echo "                 VAULT_ADDR"
  echo "                 VAULT_TOKEN"
  echo "                 FOUNDATION_NAME"
  echo ""
  exit 1
fi

export VAULT_PATH_PASSWORDS=secret/$PRODUCT_NAME-$FOUNDATION_NAME-passowrds
export VAULT_PATH_IPS=secret/$PRODUCT_NAME-$FOUNDATION_NAME-ips
export VAULT_PATH_PROPS=secret/$PRODUCT_NAME-$FOUNDATION_NAME-props

