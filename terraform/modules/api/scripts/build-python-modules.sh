#!/bin/bash
export DIR=$(dirname "$0")
export PY_DIR="python"
export PKG_DIR="packages"

cd "${DIR}/.."
echo ${PWD}

rm -rf ${PY_DIR}

python3 -m venv venv
source venv/bin/activate

pip3 install -r requirements.txt -t ${PY_DIR}

echo $PWD
zip -r packages/python-modules.zip python

rm -rf scripts/venv
rm -rf ${PY_DIR}
