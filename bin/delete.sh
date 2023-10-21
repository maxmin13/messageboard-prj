
# shellcheck disable=SC1091

## python 3.11

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace
  
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../.. && pwd)"
DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}"/datacenter-prj

echo "DATACENTER_PROJECT_DIR: ${DATACENTER_PROJECT_DIR}"

cd "${DATACENTER_PROJECT_DIR}"/bin

chmod 755 delete.sh
./delete.sh

echo "Datacenter deleted."
