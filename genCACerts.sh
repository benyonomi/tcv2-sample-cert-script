#!/bin/bash

printout () {
  echo
  echo "################################################################"
  printf "    ${1}\n"
  echo "################################################################"
}

echo -n "Enter your registration code. You get this from the ThinCloud Dashboard home page: "
read registrationCode

#Check to ensure it is not null and 64 characters long:
if [ -z "$registrationCode" ]
then
  printout "ERROR: registration code cannot be empty\n \
   You get this from the ThinCloud Dashboard home page"
  echo
  exit 9
elif [ ${#registrationCode} -ne 64 ]
then 
  printout "ERROR: registration code must be 64 characters\n \
   You get this from the ThinCloud Dashboard home page"
  echo
  exit 9
fi

echo -n "Enter your Company Name: "
read organization

if [ -z "$organization" ]
then
  printout "ERROR: Company cannot be blank"
  echo
  exit 9
fi

#Check for null

#Create CA key
printout "Creating CA Key"
openssl genrsa \
  -out certs/customCA/sampleCACertificate.key 2048

#Create CA Key CSR
printout "Creating CA Key CSR"
openssl req \
  -new \
  -sha256 \
  -key certs/customCA/sampleCACertificate.key \
  -nodes \
  -out certs/customCA/sampleCACertificate.csr \
  -subj "/C=US/O=${organization}"

#Create CA certificate
printout "Creating CA Certificate"
openssl x509 \
  -req \
  -days 3650 \
  -extensions v3_ca \
  -in certs/customCA/sampleCACertificate.csr \
  -signkey certs/customCA/sampleCACertificate.key \
  -out certs/customCA/sampleCACertificate.pem

#Create private verification key
printout "Creating Private Verification Key"
openssl genrsa \
  -out certs/customCA/privateKeyVerification.key 2048

#Create private verification key CSR
printout "Creating Private Verification Key CSR"
openssl req \
  -new \
  -key certs/customCA/privateKeyVerification.key \
  -out certs/customCA/privateKeyVerification.csr \
  -subj "/C=US/O=${organization}/CN=${registrationCode}"

#Create verification certificate
printout "Creating Verification Certificate"
openssl x509 \
  -req \
  -in certs/customCA/privateKeyVerification.csr \
  -CA certs/customCA/sampleCACertificate.pem \
  -CAkey certs/customCA/sampleCACertificate.key \
  -CAcreateserial \
  -out certs/customCA/privateKeyVerification.crt \
  -subject \
  -days 365 \
  -sha256 

#print Certificates
echo
printout "The two certificates below are used when registering \n\
    a new ThinCloud CA in the Console (Settings->IoT CA->Create)"
printf "\nCA Cert: (certs/sampleCA/sampleCACertificate.pem)\n\n"
cat certs/customCA/sampleCACertificate.pem
printf "\nVerification Cert: (certs/sampleCA/privateKeyVerification.crt)\n"
echo
cat certs/customCA/privateKeyVerification.crt
printout "DONE with CA Certificate and Verification Certificate."

exit 0
