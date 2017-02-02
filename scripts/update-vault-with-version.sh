
vault read --format=json $VAULT_PROPS_PATH | jq .data > vault-props.json

# product_version=$(cat )

vault write @vault-props.json 
