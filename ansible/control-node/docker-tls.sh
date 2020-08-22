HOST=worker.access.alpm.io

mkdir -p docker-tls

pushd docker-tls || exit

# CA Keypair
openssl genrsa -out ca-key.pem 4096

openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem -subj "/C=CH/ST=Zuerich/L=Zuerich/O=ACCESS/OU=ACCESS/CN=docker"

# Server Keypair
openssl genrsa -out server-key.pem 4096

openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

echo subjectAltName = DNS:$HOST,IP:192.168.205.11 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf

openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf

# Client Authentication
openssl genrsa -out docker-client-key.pem 4096
openssl req -subj '/CN=client' -new -key docker-client-key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out docker-client-cert.pem -extfile extfile-client.cnf

# Cleanup
rm -v client.csr server.csr extfile.cnf extfile-client.cnf

popd

