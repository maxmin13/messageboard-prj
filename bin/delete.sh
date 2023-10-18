#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

export MESSAGEBOARD_PROJECT_DIR
MESSAGEBOARD_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
export WORKSPACE_DIR
WORKSPACE_DIR="$(cd "${MESSAGEBOARD_PROJECT_DIR}" && cd .. && pwd)" 
export DATACENTER_PROJECT_DIR
DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}/datacenter-prj"

cd "${DATACENTER_PROJECT_DIR}"/bin

chmod 755 delete.sh

./delete.sh
