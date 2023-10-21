#!/bin/bash 
# shellcheck disable=SC1091

############################################################################
# The script creates a datacenter on AWS and installs a web application
#
# run:
#    export REMOTE_USER_PASSWORD=<instance remoter user pwd, eg: awsadmin>
#    ./make.sh
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

if [[ ! -v REMOTE_USER_PASSWORD ]]
then
  echo "ERROR: environment variable REMOTE_USER_PASSWORD not set!"
  exit 1
fi

# echo "WORKSPACE_DIR: ${WORKSPACE_DIR}"
# echo "MESSAGEBOARD_PROJECT_DIR: ${MESSAGEBOARD_PROJECT_DIR}"
# echo "DATACENTER_PROJECT_DIR: ${DATACENTER_PROJECT_DIR}"
# echo "PYTHONPATH: ${PYTHONPATH}"

######################
# DATACENTER PROJECT #
######################

# override the default configuration files in datacenter-prj.
cp "${MESSAGEBOARD_PROJECT_DIR}/provision/playbooks/variables/datacenter.json" "${DATACENTER_PROJECT_DIR}"/config
cp "${MESSAGEBOARD_PROJECT_DIR}/provision/playbooks/variables/hostedzone.json" "${DATACENTER_PROJECT_DIR}"/config

echo "Datacenter project config files set."

cd "${WORKSPACE_DIR}"

if [[ ! -d "${DATACENTER_PROJECT_DIR}" ]]
then
  git clone git@github.com:maxmin13/datacenter-prj.git 

  echo "Datacenter project cloned."
else
    echo "Datacenter project already cloned."
fi

cd "${DATACENTER_PROJECT_DIR}"/bin

chmod 755 make.sh
./make.sh

echo "Datacenter created."
echo "Provisioning datacenter instance ..."

chmod 755 provision.exp
./provision.exp

echo "Datacenter provisioned."

########################
# MESSAGEBOARD PROJECT #
########################

{
    python -m venv ${MESSAGEBOARD_PROJECT_DIR}/.venv
    source "${MESSAGEBOARD_PROJECT_DIR}"/.venv/bin/activate
    python3 -m pip install -r "${MESSAGEBOARD_PROJECT_DIR}"/requirements.txt
    deactivate
} > /dev/null

echo "Messageboard virtual environment created."

cd "${MESSAGEBOARD_PROJECT_DIR}"/bin

echo "Installing messageboard application ..."

chmod 755 provision.exp
./provision.exp

echo "Messageboard application installed."
