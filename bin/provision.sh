#!/bin/bash 
# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

###########################################################################
## The script installs the messageboard application on an existing AWS 
## datacenter using Ansible.
## Ansible connects to the instances with SSH connection plugin.
## Ansible uses Dynamic inventory plugin aws_ec2 to create a dynamic 
## inventory of the AWS instances.
## see: ansible.cfg, transport=ssh, enable_plugins = aws_ec2
##
## run:
##
## export AWS_AWS_REMOTE_USER=<remote AWS instance user, eg: awsadmin>
## export AWS_AWS_REMOTE_USER_PASSWORD=<remote AWS instance user pwd, eg: awsadmin>
##
## ./provision.exp 
##
###########################################################################

if [[ ! -v AWS_REMOTE_USER ]]
then
  echo "ERROR: environment variable AWS_REMOTE_USER not set!"
  exit 1
fi

if [[ ! -v AWS_REMOTE_USER_PASSWORD ]]
then
  echo "ERROR: environment variable AWS_REMOTE_USER_PASSWORD not set!"
  exit 1
fi

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
export MESSAGEBOARD_PROJECT_DIR="${WORKSPACE_DIR}"/messageboard-prj

ANSIBLE_PLAYBOOK_CMD="${MESSAGEBOARD_PROJECT_DIR}"/.venv/bin/ansible-playbook

########################
##### UPDATE SYSTEM ####
########################

echo "Upgrading the instance ..."

cd "${MESSAGEBOARD_PROJECT_DIR}"/provision || exit

 "${ANSIBLE_PLAYBOOK_CMD}" playbooks/upgrade.yml

echo "Instance upgraded."

#################
##### DJANGO ####
#################

echo "Installing Django web application ..."

"${ANSIBLE_PLAYBOOK_CMD}" playbooks/deploy-django.yml

echo "Django web application installed."
echo "Messageboard application deployed."
