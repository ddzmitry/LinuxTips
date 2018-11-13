### SSL


> Check Certificate : SSL usually on port 443 
```
openssl s_client -connect google.com:443 < /dev/null
```
* _Will return .PEM Certificate_

```sh
s_client -connect google.com:443 < /dev/null | openssl x509 -in /dev/stdin/ -text -noout


```
* _Will return better output .PEM Certificate_

```
depth=2 OU = GlobalSign Root CA - R2, O = GlobalSign, CN = GlobalSign
verify return:1
depth=1 C = US, O = Google Trust Services, CN = Google Internet Authority G3
verify return:1
depth=0 C = US, ST = California, L = Mountain View, O = Google LLC, CN = *.google.com
verify return:1
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 7914315497878224946 (0x6dd54c0373668032)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, O = Google Trust Services, CN = Google Internet Authority G3
        Validity
            Not Before: Oct 23 16:53:00 2018 GMT
            Not After : Jan 15 16:53:00 2019 GMT
        Subject: C = US, ST = California, L = Mountain View, O = Google LLC, CN = *.google.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
```

#### Types of certificates
> Domain Validated 
```
Basic Small or medium level websites do not work with any sensitive information 
Comes up with Wildcard and Miulti Domain featurs 
Reissus as many times as needed during the validity period
```
> Organization Validated
```
Business identity level trust, organization name printed in certificate
Organization name is validated and is a part of the certificate
```
> Extended Validated (Complete)
```
Up to 10 days to issue
High 256-bit encryption with 2048-bit Key Length
Multi domain with SAN (Subject Alternate Name) only
```
#### Encryption Algorithms 

```
Private/Symmetric Key Encryption Algorithm
Public/Asymmetric Key Encryption Algorithm
Hashing Algorithms
```

#### Observe handshake protocol 
```
openssl s_client -connect qualys.com:443 </dev/null2>/dev/null
```

#### Certificate Request and Signing 
```
openssl genrsa -out mysite.key 4096
openssl req -new -key mysite.key - out mysite.csr

CSR - Certificate Sign Request 
1. CA calculates the SHASUM of the certificate's data section
2. Encrypts the cchecksum value using CA's private key
3. Append the signature certificate and send back to the requester


or make it self-signed

Generate he private key and self signed certificate for 365 days 
openssl req -x509 -newkey rsa:4096 -keyout mysite.key -out mysite.crt -days 365
To see containt of .crt
openssl x509 -in mysite.crt -text -noout

Sigened myself =) 

   Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, ST=NC, L=Charlotte, O=Dzmitry, OU=Dzmitry, CN=Dzmitry/emailAddress=ssss@yahoo.com
        
        
```

### Certificate installatinon
```
https://www.digicert.com/csr-ssl-installation/ubuntu-server-with-apache2-openssl.htm#ssl_certificate_install
https://www.digicert.com/ssl-certificate-installation.htm


Apache
 <VirtualHost 192.168.0.1:443>
 DocumentRoot /var/www/
 SSLEngine on
 SSLCertificateFile /path/to/your_domain_name.crt (or .pem for Nginx)
 SSLCertificateKeyFile /path/to/your_private.key
 SSLCertificateChainFile /path/to/DigiCertCA.crt
 </VirtualHost>
 
```

### Commands 
```
s_client
	openssl s_client -connect qualys.com:443 < /dev/null
	openssl s_client -showcerts -connect www.google.com:443 < /dev/null     #show all inter. certs too
	openssl s_client -connect -tls1_2 qualys.com:443 < /dev/null 	       #connect using TLSv1.2 only

x509
	openssl x509 -in www.google.com.crt -noout –text  #decode the crt file
	openssl s_client -connect google.com:443 < /dev/null 2>/dev/null | openssl x509  -in /dev/stdin -noout –text  #take input from stdin spit by s_client
	openssl s_client -connect google.com:443 < /dev/null 2>/dev/null | openssl x509 –noout –dates #check expiry date

genrsa/rsa
	openssl genrsa -out mysite.key 4096                  #generate 4096 bit rsa key
	openssl rsa -noout -text -check -in mysite.key       #display the private key components
	openssl rsa -in mysite.key -pubout > mysite.key.pub  #extract public key
	openssl rsa -in mysite.key.pub -pubin -text –noout   #display the public key components

req
	openssl req -new -key mysite.key -out mysite.csr  #new CSR, send this to CA for signing
	openssl req -x509 -newkey rsa:4096 -keyout mysite.key -out mysite.crt -days 365 #self signed cert

s_server
	openssl s_server -cert mycert.crt -key mysite.key -www -accept 4443 #start ssl server on port 4443

ciphers
	openssl ciphers -v ['DHE-RSA-AES256-SHA'] #displays all without a cipher arguement

crl
	curl -s http://pki.google.com/GIAG2.crl  | openssl crl -inform DER -text -noout -in /dev/stdin

Miscellaneous 
	openssl x509 -noout -modulus mysite.crt | openssl sha256  #all md5sums should be 
	openssl req -noout -modulus mysite.csr | openssl sha256   #the same if they belong
	openssl rsa -noout -modulus mysite.key | openssl sha256   #to the same website

```

```
dgst
	openssl dgst -sha256 -sign privkey.pem -out input_message.tar.gz.sig input_message.tar.gz        #sign
	openssl dgst -sha256 -verify pubkey.pem -signature input_message.tar.gz.sig input_message.tar.gz #verify

enc
	openssl enc -aes-256-cbc -salt -in file.txt -out file.txt.enc [-k PASS]   #encrypt
	openssl enc -aes-256-cbc -d -in file.txt.enc -out file.txt [-k PASS]      #decrypt

base64
	openssl base64 -in file.txt -out file.txt.base64                          #base64 encoding
	openssl base64 -d -in file.txt.base64 -out file.txt                       #base64 decoding

ecparam
	openssl ecparam -list_curves                                           #list all ECC curves
	openssl ecparam -name secp256k1 -genkey -noout -out secp256k1-key.pem  #create key for curve secp256k1

passwd
	openssl passwd -1 -salt alphanumeric MyPassword   #create shadow-style password

rand
	openssl rand -out random-data.bin 64              #create 64bytes random data
	head -c 64 /dev/urandom | openssl enc -base64     #get 64 random bytes from urandom and base64 encode

```