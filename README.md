# ThinCloud v2 Sample Cert Scripts

These scripts will help you do the following:
1. Create a Sample Certificate Authority (CA)
1. Use the CA to generated the CA certificate and verification certificate for registering with ThinCloud
1. Create a device certificate that can be used for connecting a device to ThinCloud

## Prerequisites
* bash installed in /bin/bash
* curl installed
* openssl installed
* Registration Code (from the ThinCloud Dashboard)
* Company Name (Name of your company for the CA)
You will be prompted for the last two items while running the script

## Running the script
Run the following driver script to do all 3 functions
```bash
/bin/bash createCAandDeviceCert.sh
```
A certs directory will be created with 3 subfolders. For example:
```bash
drwxr-xr-x  9 ben  staff   288B Apr 30 18:01 customCA
drwxr-xr-x  3 ben  staff    96B Apr 30 18:01 AmazonCA
drwxr-xr-x  7 ben  staff   224B Apr 30 18:01 device-2020-04-30-18-01-41
```
* customCA - contains the CA certificates
* AmazonCA - contains the Amazon Root certificate for connecting a device to ThinCloud
* device-YYYY-MM-DD-HH-MM-SS - contains the device certificate

While running the script, you will be given the necessary information to register the CA with ThinCloud For example:

```
################################################################
    The two certificates below are used when registering 
    a new ThinCloud CA in the Console (Settings->IoT CA->Create)
################################################################

CA Cert: (certs/sampleCA/sampleCACertificate.pem)

-----BEGIN CERTIFICATE-----
MIICuDCCAaACC***************************************************
****************************************************************
****************************************************************
********************************UB58vw==
-----END CERTIFICATE-----

Verification Cert: (certs/sampleCA/privateKeyVerification.crt)

-----BEGIN CERTIFICATE-----
MIIDAzCC********************************************************
****************************************************************
****************************************************************
****************************************************************
*****YOvCQ==
-----END CERTIFICATE-----
```

You will also be given the device specific information at the end. For example:
```
################################################################
    Here are the files for connecting your device to ThinCloud:
    Client Key: certs/device-2020-04-30-18-01-41/deviceCert.key
    Client Cert: certs/device-2020-04-30-18-01-41/deviceCertAndCACert.crt
    CA file for ThinCloud: certs/AmazonCA/AmazonRootCA.pem
    The MQTT Client ID for this device is: 42aa****************aa1
################################################################
```



## Creating additional device certificates
Device certificates are created in their own unique subfolder with the timestamp it was created under the certs directory. To create another device certificate, you only need to run the following script:
```bash
/bin/bash genDeviceCert.sh
```
This uses the existing CA to generate new certificates.
