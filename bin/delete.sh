#!/bin/bash 
# shellcheck disable=SC1091

##############################################################################
# The script deletes a datacenter on AWS and the messageboard application.
#
# run:
##
## export AWS_REMOTE_USER=<remote AWS instance user, eg: awsadmin>
## export AWS_REMOTE_USER_PASSWORD=<remote AWS instance user pwd, eg: awsadmin>
#
#    ./delete.sh
#
##############################################################################

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

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

# directory where the datacenter project is downloaded from github
# see: name_messageboard_box file
DATACENTER_DIR="${WORKSPACE_DIR}"/datacenter-prj

# directory where the messagboard project is downloaded from github
# see: name_messageboard_box file
MESSAGEBOARD_DIR="${WORKSPACE_DIR}"/messageboard-prj

#######################################
# DATACENTER ENVIRONMENT AND INSTANCE #
#######################################

cd "${WORKSPACE_DIR}"

if [[ ! -d "${DATACENTER_DIR}" ]]
then
  git clone git@github.com:maxmin13/datacenter-prj.git 

  echo "AWS datacenter cloned."
else
  echo "AWS datacenter already cloned."
fi

# override the default configuration files in datacenter-prj.
cp "${MESSAGEBOARD_DIR}/config/datacenter.json" "${DATACENTER_DIR}"/config
cp "${MESSAGEBOARD_DIR}/config/hostedzone.json" "${DATACENTER_DIR}"/config
cp "${MESSAGEBOARD_DIR}/provision/inventory/group_vars/name_messageboard_box" "${DATACENTER_DIR}"/provision/inventory/group_vars

echo "Datacenter config files set."

cd "${DATACENTER_DIR}"/bin

echo "Deleting AWS datacenter ..."

chmod 755 delete.sh
./delete.sh

echo "AWS datacenter deleted."

cd "${WORKSPACE_DIR}"

if [[ -d datacenter-prj ]]
then
  rm -rf datacenter-prj/
fi
  
echo "Messageboard application deleted."  
  
  
