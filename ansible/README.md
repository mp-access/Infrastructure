# Ansible

This folder includes everything needed in order to set up ACCESS using ansible.

## TLS Mutual Authentication for docker daemon
Run `docker-tls.sh` to generate the full set of certificates needed.
It will create all files in a directory called docker-tls

```bash
chmod u+x docker-tls.sh
./docker-tls.sh
```

The files need to be encrypted and copied to `roles/worker/files/tls`:
```bash
cp docker-tls/* roles/worker/files/tls/

ansible-vault encrypt roles/worker/files/tls/*
```

Then run setup with:
```bash
ansible-playbook -i vm.hosts --tags "worker" --ask-vault-pass worker.yml
```

To test the authenticated connection:
```bash
docker --tlsverify --tlscacert=docker-tls/ca.pem --tlscert=docker-tls/docker-client-cert.pem --tlskey=docker-tls/docker-client-key.pem -H=192.168.205.11:2376 info
```

## Test System
It also includes the definition of a test system using two VMs provisioned using vagrant.
These two VMs are used to test ansible without needing to have two actual servers somewhere. 
The vagrant script will handle creating the VMs and connecting them using a private network between them.

* VM1: access. This is where the core access services are deployed.
    * Frontend, backend, Keycloak
* VM2: worker. This is the sandbox where the execution takes place.

### Requirements
* Virtualbox
* vagrant

### Getting Started
To create and start the VMs:
```bash
vagrant up
```

To pause the VMs:
```bash
vagrant suspend
```

To resume the VMs:
```bash
vagrant resume
```

To remove the VMs:
```bash
vagrant destroy
```

To ssh into the VMs:
```bash
vagrant ssh access
or
vagrant ssh worker
```
