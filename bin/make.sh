#!/bin/bash 
# shellcheck disable=SC1091

##############################################################################
# The script creates a datacenter on AWS and installs the messageboard
# Django application.
#
# run:
# export AWS_REMOTE_USER=<remote AWS instance user, eg: awsadmin>
# export AWS_REMOTE_USER_PASSWORD=<remote AWS instance user pwd, eg: awsadmin>
#
#    ./make.sh
#
##############################################################################

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace
  
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
export MESSAGEBOARD_PROJECT_DIR="${WORKSPACE_DIR}"/messageboard-prj
export DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}"/datacenter-prj

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

#######################################
# DATACENTER ENVIRONMENT AND INSTANCE #
#######################################

cd "${WORKSPACE_DIR}"

if [[ ! -d "${DATACENTER_PROJECT_DIR}" ]]
then
  git clone git@github.com:maxmin13/datacenter-prj.git 

  echo "Datacenter project cloned."
else
  echo "Datacenter project already cloned."
fi

# override the default configuration files in datacenter-prj.
cp "${MESSAGEBOARD_PROJECT_DIR}/config/datacenter.json" "${DATACENTER_PROJECT_DIR}"/config
cp "${MESSAGEBOARD_PROJECT_DIR}/config/hostedzone.json" "${DATACENTER_PROJECT_DIR}"/config

# copy Ansible group_vars file for the message-board application
cp "${MESSAGEBOARD_PROJECT_DIR}/provision/inventory/group_vars/name_messageboard_box" "${DATACENTER_PROJECT_DIR}/provision/inventory/group_vars"

echo "Datacenter project config files set."

cd "${DATACENTER_PROJECT_DIR}"/bin

echo "Creating datacenter ..."

chmod 755 make.sh
./make.sh

echo "Datacenter created."
echo "Provisioning the instance ..."

chmod 755 provision.sh
./provision.sh

echo "Datacenter provisioned."

###########################
# MESSAGEBOARD DJANGO APP #
###########################

echo "Installing Django message-board application ..."

{
    python -m venv "${MESSAGEBOARD_PROJECT_DIR}"/.venv
    source "${MESSAGEBOARD_PROJECT_DIR}"/.venv/bin/activate
    python3 -m pip install -r "${MESSAGEBOARD_PROJECT_DIR}"/requirements.txt
    deactivate
} > /dev/null

echo "Messageboard virtual environment created."

cd "${MESSAGEBOARD_PROJECT_DIR}"/bin

chmod 755 provision.sh
./provision.sh

cd "${WORKSPACE_DIR}"

if [[ -d datacenter-prj ]]
then
  rm -rf datacenter-prj/
fi
  
echo "Messageboard Django application installed."  
  
  
