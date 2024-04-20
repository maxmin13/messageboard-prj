#!/bin/bash 
# shellcheck disable=SC1091

##############################################################################
# The script creates a datacenter on AWS and installs the messageboard
# application.
#
# run:
#
# export AWS_ACCESS_KEY_ID=xxxxxx
# export AWS_SECRET_ACCESS_KEY=yyyyyy
# export AWS_DEFAULT_REGION=zzzzzz
#
#    ./make.sh
#
##############################################################################

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

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

  echo "AWS datacenter project cloned."
else
  echo "AWS datacenter project already cloned."
fi

# override the default configuration files in datacenter-prj.
cp "${MESSAGEBOARD_DIR}/config/datacenter.json" "${DATACENTER_DIR}"/config
cp "${MESSAGEBOARD_DIR}/config/hostedzone.json" "${DATACENTER_DIR}"/config
cp "${MESSAGEBOARD_DIR}/provision/inventory/group_vars/name_messageboard_box" "${DATACENTER_DIR}"/provision/inventory/group_vars

echo "Datacenter config files set."
echo "Creating AWS datacenter ..."

cd "${DATACENTER_DIR}"/bin
chmod 755 make.sh
./make.sh

echo "AWS datacenter created."
echo "Provisioning the instance ..."

export MESSAGEBOARD_DIR

cd "${DATACENTER_DIR}"/bin
chmod 755 provision.sh
./provision.sh

echo "AWS datacenter provisioned."

###########################
# MESSAGEBOARD DJANGO APP #
###########################

echo "Deploying messageboard application ..."

# copy the private key from datacenter-prj
private_key_nm='messageboard-box'
if [[ -f "${DATACENTER_DIR}/access/${private_key_nm}" ]]
then
	rm -f "${MESSAGEBOARD_DIR}/access/${private_key_nm}"
	cp "${DATACENTER_DIR}/access/${private_key_nm}" "${MESSAGEBOARD_DIR}"/access/ 
fi

echo "Private key copied to the messageboard project."
echo "Private key directory ${MESSAGEBOARD_DIR}/access"

cd "${MESSAGEBOARD_DIR}"/bin

# variables for messageboard-prj:name_messageboard_box file:
export DATACENTER_DIR

chmod 755 provision.sh
./provision.sh

cd "${WORKSPACE_DIR}"

if [[ -d datacenter-prj ]]
then
  rm -rf datacenter-prj/
fi
  
echo "Messageboard application installed."  
  
  
