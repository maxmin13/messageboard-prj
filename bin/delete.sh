#!/bin/bash 
# shellcheck disable=SC1091

############################################################################
# The script deletes AWS datacenter and web application.
#
# run:
#    export REMOTE_USER=<remote instance user, eg: awsadmin>
#    export REMOTE_USER_PASSWORD=<remote instance user pwd, eg: awsadmin>
#
#    ./delete.sh
#
############################################################################

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace
  
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
export MESSAGEBOARD_PROJECT_DIR="${WORKSPACE_DIR}"/messageboard-prj
export DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}"/datacenter-prj
export PYTHONPATH="${MESSAGEBOARD_PROJECT_DIR}"/src

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

######################
# DATACENTER PROJECT #
######################

cd "${WORKSPACE_DIR}"

if [[ ! -d "${DATACENTER_PROJECT_DIR}" ]]
then
  git clone git@github.com:maxmin13/datacenter-prj.git 

  echo "Datacenter project cloned."
else
  echo "Datacenter project already cloned."
fi

# override the default configuration files in datacenter-prj.
cp "${MESSAGEBOARD_PROJECT_DIR}/provision/playbooks/variables/datacenter.json" "${DATACENTER_PROJECT_DIR}"/config
cp "${MESSAGEBOARD_PROJECT_DIR}/provision/playbooks/variables/hostedzone.json" "${DATACENTER_PROJECT_DIR}"/config

echo "Datacenter project config files set."

cd "${DATACENTER_PROJECT_DIR}"/bin

chmod 755 delete.sh
./delete.sh

cd "${WORKSPACE_DIR}"

if [[ -d datacenter-prj ]]
then
  rm -rf datacenter-prj
fi
  
echo "Datacenter deleted."  
