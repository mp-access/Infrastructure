#!/bin/bash
set -Eeuo pipefail

DEFAULT=vm.hosts
RESULT=${INVENTORY:-$DEFAULT}

echo "Running against '$RESULT' inventory file..."

ansible-playbook -i "$RESULT" worker.yml
ansible-playbook -i "$RESULT" access.yml
