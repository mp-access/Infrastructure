# TODO
Notes from an install from scratch - see also 'TODO' in the rest of the README


Infrastructure/ops/ansible/control-node/roles/docker/tasks/main.yml
specify packages to be installed remotely

acl, net-tools


TODO
cp -R host_files/info1-staging/git host_files/access-tutorial/
cp roles/access/files/conf-no-tls.nginx.j2 host_files/access-tutorial/
cp roles/access/files/conf-selfsigned.nginx host_files/access-tutorial/


Enable inpersonate:
/auth -> clients -> frontend, edit- -> Base URL setzen auf https://host.com

Email setup in keycloak









# Ansible

This folder includes everything needed in order to set up ACCESS using ansible.

## Directory structure

```bash
├── .vault_pass.txt # needs to be created
├── Dockerfile
├── access
├── access.yml
├── dev.hosts
├── docker-compose.yml
├── docker-tls
├── docker-tls\ copy
├── docker-tls.sh
├── host_files
├── host_vars
├── roles
├── sshconfig
├── vm.hosts
└── worker.yml
```

## Vault password

Create a file called `.vault_pass.txt` and export its location as follows:

```bash
echo -n '{{ vault_password }}' > ./.vault_pass.txt
export ANSIBLE_VAULT_PASSWORD_FILE=$(pwd)/.vault_pass.txt
```

This way you won't have to set the vault password with every command.

**`.vault_pass.txt` Should not be committed. It's ignored in `.gitignore`.**

TODO:
## Create an inventory file
TODO: Copy existing hosts file and update with server coordinates

## Create host vars folders and files

## Add repositories.json

## Realm provisioning script
Add baseurl to provisioning script so that the impersonation feature works out of the box


## TLS Mutual Authentication for docker daemon
Edit docker-tls.sh for correct hostnames and IPs.

Copy dev.hosts to arbitrary name (e.g. staging.hosts), edit names and ips.

Run `docker-tls.sh` to generate the full set of private keys and certificates needed.
It will create all files in a directory called `docker-tls`.

```bash
chmod u+x docker-tls.sh
./docker-tls.sh
```


This will generate the following files and folders:

```bash
docker-tls
├── ca-key.pem
├── ca.pem
├── ca.srl
├── main
│   ├── ca.pem
│   ├── client-cert.pem
│   └── client-key.pem
└── worker
    ├── ca.pem
    ├── server-cert.pem
    └── server-key.pem
```


The files under `{main,worker}` need to moved to `host_files/{{ inventory_hostname }}/` in order for ansible to pick them up.
Here an example with the vm hosts:

```bash
host_files/
├── access-vm-main
│   ├── ca.pem
│   ├── client-cert.pem
│   └── client-key.pem
└── access-vm-worker
    ├── ca.pem
    ├── server-cert.pem
    └── server-key.pem
```

**The files must be encrypted before commit. To encrypt run:**
```bash
ansible-vault encrypt host_files/access-vm-main/*
ansible-vault encrypt host_files/access-vm-worker/*
```

TODO
Put ansible_user=ubuntu in inventory file (all:vars if necessary)

TODO
Before playbook: create/copy files in host_vars/x/{vars,vault}.yml, change user/pwds accordingly

Then run setup with:
```bash
ansible-playbook -i vm.hosts worker.yml
ansible-playbook -i vm.hosts access.yml
```

To test the authenticated connection (with the unencrypted files):
```bash
docker --tlsverify --tlscacert=ca.pem --tlscert=client-cert.pem --tlskey=client-key.pem -H=192.168.205.11:2376 info
```

## SSH Deploy Keys for private repositories
Run the following script to create the necessary deploy keys:
```bash
chmod u+x generate-repo-keys.sh
./generate-repo-keys.sh
```

Move the generated files to `host_files/{{ inventory_hostname }}/git/` and encrypt the files with:
```bash
ansible-vault encrypt host_files/access-vm-main/{{ inventory_hostname }}/git/*
```

TODO:
also the `ssh_config`


## Install ACCESS
The entire process is scripted using ansible. 
Once the steps above are done (only needed once for every new deployment), the following two commands can be used:

```bash
ansible-playbook -i vm.hosts worker.yml
ansible-playbook -i vm.hosts access.yml
```

This will:
 * install Docker on both target machines
 * Expose the Docker daemon on the worker node to the main ACCESS node
 * Create a self signed TLS certificate for the web application
 * Download and run ACCESS
 * Keycloak:
    * Initialize admin user
    * Initialize ACCESS realm 
    
    
The entire process may take some time (10-15 minutes) but is completely automated. 
Once it is finished, ACCESS should be up and running and accessible.


## Test System
This folder also includes the definition of a test environment composed of two VMs provisioned using vagrant.
These two VMs are used to test ansible without needing to have two actual servers somewhere. 
The vagrant script will handle creating the VMs and connecting them using a private network between them.

* VM1: access. This is where the core access services will be deployed.
    * Frontend, backend, Keycloak
* VM2: worker. This is the sandbox where the execution takes place.

### Requirements
* Virtualbox
* vagrant

### Getting Started
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


# Testing connection to hosts
You can use the ping module to verify the connection to an inventory
```bash
ansible -i digitalocean.hosts all -m ping
```
