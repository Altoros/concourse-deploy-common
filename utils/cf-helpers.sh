if [[ -z $CF_API_URL || -z $CF_ADMIN_USERNAME || -z $CF_ADMIN_PASSWORD ]]; then
  echo "ERROR: one of the following environment variables is not set: "
  echo ""
  echo "                 VAULT_ADDR"
  echo "                 VAULT_TOKEN"
  echo "                 FOUNDATION_NAME"
  echo ""
  exit 1
fi

function cf_authenticate_and_target() {
  cf api $CF_API_URL --skip-ssl-validation
  cf auth $CF_ADMIN_USERNAME $CF_ADMIN_PASSWORD
}

function cf_target_org_and_space() {
  ORG=$1
  SPACE=$2

  if ! (cf orgs | grep "^${ORG}$"); then
    cf create-org $ORG
  fi
  cf target -o $ORG

  if ! (cf spaces | grep "^${SPACE}$"); then
    cf create-space $SPACE
  fi
  cf target -s $SPACE
}

function cf_create_service() {
  SERVICE_NAME=$1
  PLAN=$2
  SERVICE_INSTANCE_NAME=$3

# check if $SERVICE_NAME is in cf marktplace
# check if $SERVICE_INSTANCE_NAME exists
# if $SERVICE_INSTANCE_NAME does not exist - create it

}
