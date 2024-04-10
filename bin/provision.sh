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
## export AWS_REMOTE_USER=awsadmin
## export AWS_REMOTE_USER_PASSWORD=awsadmin
## export AWS_INSTANCE_NAME=<ex: admin-box (see: datacenter.json file, field: Datacenter.Instances[].name >
## export PROJECT_DIR=<ex: /home/vagrant/workspace/messageboard-prj >   
## export PRIVATE_KEY_FILE=<ex: /home/vagrant/workspace/datacenter-prj/access/message-box >  
##
## ./provision.sh 
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

if [[ ! -v AWS_INSTANCE_NAME ]]
then
  echo "ERROR: environment variable AWS_INSTANCE_NAME not set!"
  exit 1
fi

if [[ ! -v PROJECT_DIR ]]
then
  echo "ERROR: environment variable PROJECT_DIR not set!"
  exit 1
fi

if [[ ! -v PRIVATE_KEY_FILE ]]
then
  echo "ERROR: environment variable PRIVATE_KEY_FILE not set!"
  exit 1
fi

echo "Creating messageboard virtual environment ..."

{
    python -m venv "${PROJECT_DIR}"/.venv
    source "${PROJECT_DIR}"/.venv/bin/activate
    python3 -m pip install -r "${PROJECT_DIR}"/requirements.txt
    deactivate
} > /dev/null

echo "Messageboard virtual environment created."

ANSIBLE_PLAYBOOK_CMD="${PROJECT_DIR}"/.venv/bin/ansible-playbook

cd "${PROJECT_DIR}"/provision || exit

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
