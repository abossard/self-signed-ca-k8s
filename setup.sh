#!/bin/sh
docker build -t api src/api
docker build -t web src/web

# create certificates
mkdir -p certs
openssl req -x509 -sha256 -newkey rsa:4096 -keyout certs/ca.key -out certs/ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'
openssl req -new -newkey rsa:4096 -keyout certs/api.key -out certs/api.csr -nodes -subj '/CN=api'
openssl x509 -req -sha256 -days 365 -in certs/api.csr -CA certs/ca.crt -CAkey certs/ca.key -set_serial 01 -out certs/api.crt

kubectl create secret generic ca-secret --from-file=ca.crt=certs/ca.crt
kubectl create secret generic api-secret --from-file=tls.crt=certs/api.crt --from-file=tls.key=certs/api.key