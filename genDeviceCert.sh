#/bin/bash

CERTS_DIR=certs/device-`date +%Y-%m-%d-%H-%M-%S`
CA_DIR=certs/customCA

mkdir -p ${CERTS_DIR}

printout () {
  echo
  echo "################################################################"
  printf "    ${1}\n"
  echo "################################################################"
}

#Generate Client Certificates
printout "Creating Device Key"
openssl genrsa \
  -out ${CERTS_DIR}/deviceCert.key 2048

printout "Creating Device Key CSR"
openssl req \
  -new \
  -key ${CERTS_DIR}/deviceCert.key \
  -out ${CERTS_DIR}/deviceCert.csr \
  -subj '/C=US/O=Yonomi'

printout "Use CA to sign the CSR and create Device Certificate"
openssl x509 \
  -req \
  -in ${CERTS_DIR}/deviceCert.csr \
  -CA ${CA_DIR}/sampleCACertificate.pem \
  -CAkey ${CA_DIR}/sampleCACertificate.key \
  -CAcreateserial \
  -out ${CERTS_DIR}/deviceCert.crt \
  -days 365 \
  -sha256

printout "Combining the device and CA certificate"
cat ${CERTS_DIR}/deviceCert.crt ${CA_DIR}/sampleCACertificate.pem > ${CERTS_DIR}/deviceCertAndCACert.crt

openssl x509 \
  -noout \
  -fingerprint \
  -sha256 \
  -inform pem \
  -in ${CERTS_DIR}/deviceCert.crt | sed 's/://g' | sed 's/SHA256 Fingerprint=//g' | tr '[:upper:]' '[:lower:]'>${CERTS_DIR}/mqtt_client.id

printout "Here are the files for connecting your device to ThinCloud:\n \
   Client Key: ${CERTS_DIR}/deviceCert.key\n \
   Client Cert: ${CERTS_DIR}/deviceCertAndCACert.crt\n \
   CA file for ThinCloud: certs/AmazonCA/AmazonRootCA.pem\n \
   The MQTT Client ID for this device is: $(cat ${CERTS_DIR}/mqtt_client.id)"
