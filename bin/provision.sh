#!/bin/bash 
# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

#########################################################################
## The script provisions an AWS instance using Ansible.
## Ansible connects to the instances with an SSH connection plugin.
## Ansible is configured to use the Dynamic inventory plugin aws_ec2 to create a dynamic 
## inventory of the AWS instances.
## see: ansible.cfg file
##
## run:
##
## AWS IAM user credentials
## export AWS_ACCESS_KEY_ID=xxxxxx
## export AWS_SECRET_ACCESS_KEY=yyyyyy
## export AWS_DEFAULT_REGION=zzzzzz
##
## Instance user credentials associated with the private key when the instance was created.
## export AWS_INSTANCE_USER=<see: datacenter.json UserName field>
## export AWS_INSTANCE_USER_PASSWORD=<see: datacenter.json UserPassword field>
##
## export DATACENTER_DIR=<directory where the datacenter project is cloned>
##
## ./provision.sh 
##
#########################################################################

# AWS IAM user credientials
if [[ ! -v AWS_ACCESS_KEY_ID ]]
then
  echo "ERROR: environment variable AWS_ACCESS_KEY_ID not set!"
  exit 1
fi

if [[ ! -v AWS_SECRET_ACCESS_KEY ]]
then
  echo "ERROR: environment variable AWS_SECRET_ACCESS_KEY not set!"
  exit 1
fi

if [[ ! -v AWS_DEFAULT_REGION ]]
then
  echo "ERROR: environment variable AWS_DEFAULT_REGION not set!"
  exit 1
fi

# AWS instance credentials associated with the primary key
# see: name_messageboard_box and datacenter.json
if [[ ! -v AWS_INSTANCE_USER ]]
then
  echo "ERROR: environment variable AWS_INSTANCE_USER not set!"
  exit 1
fi

# AWS instance user credentials associated with the primary key
# see: name_messageboard_box and datacenter.json
if [[ ! -v AWS_INSTANCE_USER_PASSWORD ]]
then
  echo "ERROR: environment variable AWS_INSTANCE_USER_PASSWORD not set!"
  exit 1
fi

# directory where the datacenter project is downloaded from github
# see: name_messageboard_box file
if [[ ! -v DATACENTER_DIR ]]
then
  echo "ERROR: environment variable DATACENTER_DIR not set!"
  exit 1
fi

# directory where the messageboard project is downloaded from github
# see: name_messageboard_box file
export MESSAGEBOARD_DIR
MESSAGEBOARD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

echo "Creating messageboard virtual environment ..."

{
    python -m venv "${MESSAGEBOARD_DIR}"/.venv
    source "${MESSAGEBOARD_DIR}"/.venv/bin/activate
    python3 -m pip install -r "${MESSAGEBOARD_DIR}"/requirements.txt
    deactivate
} > /dev/null

echo "Messageboard virtual environment created."

ANSIBLE_PLAYBOOK_CMD="${MESSAGEBOARD_DIR}"/.venv/bin/ansible-playbook

cd "${MESSAGEBOARD_DIR}"/provision || exit

########################
##### UPDATE SYSTEM ####
########################

echo "Upgrading instances ..."

"${ANSIBLE_PLAYBOOK_CMD}" playbooks/upgrade.yml 

echo "Instances upgraded."

#################
##### DJANGO ####
#################

echo "Installing Django web application ..."

"${ANSIBLE_PLAYBOOK_CMD}" playbooks/deploy-django.yml
#"${ANSIBLE_PLAYBOOK_CMD}" playbooks/deploy-messageboard-app.yml

echo "Django web application installed."
echo "Messageboard application deployed."
