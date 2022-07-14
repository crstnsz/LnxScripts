Easy Way To Convert PFX to .Crt & .Key Files In 10 Minutes
This 10-minute guide will help you to convert your .pfx file into .crt or .key file from the encrypted key using OpenSSL for free.

Image by Author | Prepared with MS PowerPoint
This seven minute guide will help you to convert your .pfx file into .crt or .key file from the encrypted key using OpenSSL for free. I kept three minutes as buffer 😉

OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose cryptography library. For more information, you can visit the official website.

Let’s say, you have already got the .pfx certificate from the SSL providers/registrars like network solution, godaddy, bigrock etc., then you are good to follow up the below steps without any hurdles.

You need to follow up below commands in order to convert files to .crt/.key easily.

Prerequisites:
OpenSSL package must be installed in your system.
You must have .pfx file for your chosen domain name.
Windows/Ubuntu/Linux system to utilize the OpenSSL package with crt
Step 1: Extract the private key from your .pfx file
openssl pkcs12 -in [yourfilename.pfx] -nocerts -out [keyfilename-encrypted.key]
This command will extract the private key from the .pfx file. Now we need to type the import password of the .pfx file. This password is used to protect the keypair which created for .pfx file. After entering import password OpenSSL requests to type another password twice. This new password is to protect the .key file. #SafetyFirst

theraxton@ubuntu:~/Downloads/SSL-certificate$ openssl pkcs12 -in samplefilename.pfx -nocerts -out samplefilenameencrypted.key 
Enter Import Password: 
Enter PEM pass phrase: 
Verifying — Enter PEM pass phrase: 
theraxton@ubuntu:~/Downloads/SSL-certificate$
Please note that, when you are going to enter the password, you can’t see against password, but they are typing in the back. Press enter once you entered your secure password.

Step 2: Extract .crt file from the .pfx certificate
openssl pkcs12 -in [yourfilename.pfx] -clcerts -nokeys -out [certificatename.crt]
After that, press enter and give the password for your certificate, hit enter again, after all — your certificate will be appears in the same directory.

theraxton@ubuntu:~/Downloads/SSL-certificate$ openssl pkcs12 -in samplefile.pfx -clcerts -nokeys -out samplefileencrypted.crt 
Enter Import Password:
Step 3: Extract the .key file from encrypted private key from step 1.
openssl rsa -in [keyfilename-encrypted.key] -out [keyfilename-decrypted.key]
We need to enter the import password which we created in the step 1. Now we have a certificate(.crt) and the two private keys ( encrypted and unencrypted).

theraxton@ubuntu:~/Downloads/SSL-certificate$ openssl rsa -in samplefilenameencrypted.key -out samplefilenameunencrypted.key 
Enter pass phrase for samplefilenameencrypted.key: 
writing RSA key
Now you can use .crt and .key file to run your Node / Angular / Java application with these obtained files.

What do you think about this article? — Is it helpful? — Please comment below.