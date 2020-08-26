#!/bin/bash
set -Eeuo pipefail

mkdir -p git_ssh_keys

ssh-keygen -t rsa -m PEM -C "access@access.com" -q -N "" -f git_ssh_keys/id_rsa_github
ssh-keygen -t rsa -m PEM -C "access@access.com" -q -N "" -f git_ssh_keys/id_rsa_gitlab
ssh-keygen -t rsa -m PEM -C "access@access.com" -q -N "" -f git_ssh_keys/id_rsa_gitlab_ifi
ssh-keygen -t rsa -m PEM -C "access@access.com" -q -N "" -f git_ssh_keys/id_rsa_bitbucket
