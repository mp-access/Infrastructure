# Ansible

This folder includes everything needed in order to set up ACCESS using ansible.

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