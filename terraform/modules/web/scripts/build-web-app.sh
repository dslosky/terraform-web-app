#!/bin/bash
export DIR=$(dirname "$0")
export DIST_DIR="dist"
cd "${DIR}/../web"

rm -rf ${DIST_DIR}

npm install
ng build -c production
