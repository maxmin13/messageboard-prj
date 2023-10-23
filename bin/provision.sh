#!/bin/bash 
# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

###########################################################################
## Installs the messageboard application on an AWS datacenter.
##
## run:
##
## export MESSAGEBOARD_PROJECT_DIR=<path to the project directory>
## export REMOTE_USER_PASSWORD=<instance remoter user pwd, eg: awsadmin>
##
## ./provision.exp 
##
###########################################################################

if [[ ! -v REMOTE_USER ]]
then
  echo "ERROR: environment variable REMOTE_USER not set!"
  exit 1
fi

if [[ ! -v REMOTE_USER_PASSWORD ]]
then
  echo "ERROR: environment variable REMOTE_USER_PASSWORD not set!"
  exit 1
fi

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
export MESSAGEBOARD_PROJECT_DIR="${WORKSPACE_DIR}"/messageboard-prj

ANSIBLE_PLAYBOOK_CMD="${DATACENTER_PROJECT_DIR}"/.venv/bin/ansible-playbook

########################
##### UPDATE SYSTEM ####
########################

echo "Upgrading the instance ..."

cd "${MESSAGEBOARD_PROJECT_DIR}"/provision || exit

 "${ANSIBLE_PLAYBOOK_CMD}" playbooks/upgrade.yml \
     --extra-vars "ansible_user=${REMOTE_USER} ansible_password=${REMOTE_USER_PASSWORD} ansible_sudo_pass=${REMOTE_USER_PASSWORD}"

echo "Instance upgraded."

#################
##### DJANGO ####
#################

echo "Installing web application ..."

"${ANSIBLE_PLAYBOOK_CMD}" playbooks/deploy-django.yml \
    --extra-vars "ansible_user=${REMOTE_USER} ansible_password=${REMOTE_USER_PASSWORD} ansible_sudo_pass=${REMOTE_USER_PASSWORD}"

echo "Web application installed."
echo "Messageboard application deployed."
