#!/bin/bash
set -Eeuo pipefail

DEFAULT_HOST=worker.access.alpm.io
DEFAULT_IP=192.168.205.11
SERVER_HOST=${HOST:-$DEFAULT_HOST}
SERVER_IP=${IP:-$DEFAULT_IP}

echo "Generating server certificate for: $SERVER_HOST. Subj AltName: DNS:$SERVER_HOST,IP:$SERVER_IP"

LIFETIME=365
BITS=4096

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit
fi

mkdir -p docker-tls/

pushd docker-tls || exit

# CA Keypair
openssl genrsa -out ca-key.pem $BITS

openssl req -new -x509 -days $LIFETIME -key ca-key.pem -sha256 -out ca.pem -subj "/C=CH/ST=Zuerich/L=Zuerich/O=ACCESS/OU=ACCESS/CN=docker"

# Server Keypair
openssl genrsa -out server-key.pem $BITS

openssl req -subj "/CN=$SERVER_HOST" -sha256 -new -key server-key.pem -out server.csr

echo subjectAltName = DNS:"$SERVER_HOST",IP:"$SERVER_IP" >>extfile.cnf
echo extendedKeyUsage = serverAuth >>extfile.cnf

openssl x509 -req -days $LIFETIME -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf

# Client Authentication
openssl genrsa -out client-key.pem $BITS
openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr
echo extendedKeyUsage = clientAuth >extfile-client.cnf
openssl x509 -req -days $LIFETIME -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile-client.cnf

# Cleanup
rm -v client.csr server.csr extfile.cnf extfile-client.cnf

# Create and move into main folder
mkdir -p main/
cp ca.pem main/
mv {client-cert,client-key}.pem main/

# Create and move into main folder
mkdir -p worker/
cp ca.pem worker/
mv {server-cert,server-key}.pem worker/

popd || exit
