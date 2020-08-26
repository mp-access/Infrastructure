FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --yes nano software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install --yes ansible
