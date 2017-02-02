#!/usr/bin/env bash
set -e

project_dir=$(readlink -f "$(dirname $0)/../..")
source $project_dir/ci/utils/load-vault-env.sh

vault read --format=yaml $VAULT_PATH_PASSWORDS vault/passwords.yml
vault read --format=yaml $VAULT_PATH_IPS       vault/ips.yml
vault read --format=yaml $VAULT_PATH_PROPS     vault/props.yml
