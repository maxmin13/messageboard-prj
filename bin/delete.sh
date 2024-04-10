#!/bin/bash 
# shellcheck disable=SC1091

##############################################################################
# The script deletes a datacenter on AWS.
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
DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}"/datacenter-prj
MESSAGEBOARD_PROJECT_DIR="${WORKSPACE_DIR}"/messageboard-prj

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

echo "Datacenter project config files set."

echo "Deleting AWS datacenter ..."

cd "${DATACENTER_PROJECT_DIR}"/bin
chmod 755 delete.sh
./delete.sh

cd "${WORKSPACE_DIR}"

if [[ -d datacenter-prj ]]
then
  rm -rf datacenter-prj/
fi
  
echo "AWS datacenter deleted."  
