#!/bin/bash
set -Eeuo pipefail

DEFAULT_HOST=gitlab.ifi.uzh.ch
HOST=${HOST:-$DEFAULT_HOST}

mkdir -p git_ssh_keys

pushd git_ssh_keys || exit

echo "Generating 10 git deploy keys for host $HOST"
for i in {0..3}; do
  ssh-keygen -t rsa -m PEM -C "access@access.com" -q -N "" -f "id_rsa_$i"
  echo "Generated key $i"
done

echo "Generating ssh config file"
rm -rf ssh_config

for i in {0..3}; do
  cat <<EOT >>ssh_config
Host $i.$HOST
  HostName $HOST
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa_$i

EOT

done

popd || exit
