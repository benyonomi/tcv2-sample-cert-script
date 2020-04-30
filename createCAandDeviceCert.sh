#!/bin/bash

printout () {
  echo
  echo "################################################################"
  printf "    ${1}\n"
  echo "################################################################"
}

mkdir -p certs/customCA
mkdir -p certs/AmazonCA

/bin/bash genCACerts.sh

if [ $? -eq 0 ]; then
  printout "Getting Amazon Root CA"
  /bin/bash getAmazonRootCA.sh
  if [ $? -eq 0 ]; then
  /bin/bash genDeviceCert.sh
  fi
fi
