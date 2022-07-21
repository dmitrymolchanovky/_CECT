#!/usr/bin/env bash

version=$1
if [$version -eq ""]; then
  wget -q https://github.com/heeus/ce/releases/latest/download/version
  fileVer="./version"
  version=$(cat "$fileVer")
fi

set -Eeuo pipefail

echo version = $version


cleanup(){
  sudo rm ./version || true
  sudo rm ./install.sh || true
}

trap cleanup EXIT

terminateScript(){
  echo "the installation process has been interrupted"
  cleanup
  exit 1
}

sudo wget -O - https://github.com/heeus/ce/releases/download/v${version}/install.sh 
sudo ./install.sh $version
