
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
  exit_on_error "Error authenticating with cf"
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
  exit_on_error "Error with authentication"
}

function cf_create_service() {
  SERVICE_NAME=$1
  PLAN=$2
  SERVICE_INSTANCE_NAME=$3

  if ! (cf marketplace | grep  "^${SERVICE_NAME}\ "); then
    exit_on_error "You need to have ${SERVICE_NAME} in your marketplace to use this product."
  fi

  if ! (cf services | grep  "^${SERVICE_INSTANCE_NAME}\ "); then
    cf create-service $SERVICE_NAME $PLAN $SERVICE_INSTANCE_NAME
    exit_on_error "Error Creating Service."
  else
    echo "The service instance $SERVICE_INSTANCE_NAME exists."
  fi
}

# Todo: think how this can be exatracted?
function exit_on_error() {
  $ERROR_MESSAGE=$1
  if [ $? != 0 ];
  then
      echo $ERROR_MESSAGE
      exit 1
  fi
}
