# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
set +o xtrace

export MESSAGEBOARD_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
export WORKSPACE_DIR="$(cd "${MESSAGEBOARD_PROJECT_DIR}" && cd .. && pwd)" 
export DATACENTER_PROJECT_DIR="${WORKSPACE_DIR}/datacenter-prj"

echo WORKSPACE_DIR $WORKSPACE_DIR
echo MESSAGEBOARD_PROJECT_DIR $MESSAGEBOARD_PROJECT_DIR
echo DATACENTER_PROJECT_DIR $DATACENTER_PROJECT_DIR

cd "${WORKSPACE_DIR}"

if [ ! -d "${DATACENTER_PROJECT_DIR}" ]
then
  git clone git@github.com:maxmin13/datacenter-prj.git
fi

cd "${DATACENTER_PROJECT_DIR}"/bin
chmod 755 make.sh
./make.sh

echo "Provisioning datacenter ..."

cd "${DATACENTER_PROJECT_DIR}"/provision
"${MESSAGEBOARD_PROJECT_DIR}"/bin/provision_datacenter.exp awsadmin

echo "Datacenter provisioned"

PYTHONPATH="${MESSAGEBOARD_PROJECT_DIR}"/src
python -m venv "${MESSAGEBOARD_PROJECT_DIR}"/.venv
source "${MESSAGEBOARD_PROJECT_DIR}"/.venv/bin/activate
python3 -m pip install -r "${MESSAGEBOARD_PROJECT_DIR}"/requirements.txt
deactivate

echo "Installing web application ..."

cd "${MESSAGEBOARD_PROJECT_DIR}"/provision
"${MESSAGEBOARD_PROJECT_DIR}"/bin/provision_messageboard.exp awsadmin

echo "Web application provisioned"
