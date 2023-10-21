#!/bin/bash 
# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace
  
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}"/datacenter-prj

echo "Deleting datacenter ..."

cd "${DATACENTER_PROJECT_DIR}"/bin

chmod 755 delete.sh
./delete.sh

echo "Datacenter deleted."
