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

## Create an inventory file
Create an inventory file by copying `./template.hosts`. Set the servers ip address or hostname.
An inventory file has this format:
```ini
[main]
{{ main_server_name }} ansible_host=10.10.10.11

[worker]
{{ worker_server_name }} ansible_host=10.10.10.12
```

The remaining explanation will use this inventory file:
```ini
[main]
access-main ansible_host=10.10.10.11

[worker]
access-worker ansible_host=10.10.10.12
```

**`access-main` and `access-worker` are called `inventory_hostname` in Ansible. This name will also be used.**

### Running ansible as non-root on the server
Ansible ssh into a server as a specific user. If you want to ssh as a non-root user, 
set the username in the inventory file:

```ini
[main]
access-main ansible_host=10.10.10.11

[worker]
access-worker ansible_host=10.10.10.12

[all:vars]
ansible_ssh_user=user
```

## Create host_vars folders
1. Copy `./host_vars/template-main` folder and call it the same name you gave the main server in the inventory file (`main_server_name`).
Call the file `./host_vars/access-main`.

2. Copy the `./host_vars/access-main/vault.template.yml` into `./host_vars/access-main/vault.yml`.
3. Create and write passwords into `./host_vars/access-main/vault.yml`
4. Set the remaining variables in `./host_vars/access-main/vars.yml`


## Create host_files folder
1. Copy `./host_files/template-main` and call it the same name you gave the main server in the inventory file (`main_server_name`).
Call the folder `./host_files/access-main`.
2. Edit `./host_files/access-main/repositories.json` with all the git repositories URLS. **Use the SSH URL**.

## TLS Mutual Authentication for docker daemon
**Edit docker-tls.sh for correct hostnames and IPs?.**

Run `docker-tls.sh` to generate the full set of private keys and certificates needed.
It will create all files in a directory called `docker-tls`.

Set `HOST` and `IP` to the domain and ip address of the **worker** server

```bash
chmod u+x docker-tls.sh
HOST=worker.info1.ch IP=10.10.10.12 ./docker-tls.sh
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
├── access-main
│   ├── ca.pem
│   ├── client-cert.pem
│   └── client-key.pem
└── access-worker
    ├── ca.pem
    ├── server-cert.pem
    └── server-key.pem
```

**The files must be encrypted before commit. To encrypt run:**
```bash
ansible-vault encrypt host_files/access-main/*
ansible-vault encrypt host_files/access-worker/*
```

To test the authenticated connection (with the unencrypted files), once the worker playbook was run:
```bash
docker --tlsverify --tlscacert=ca.pem --tlscert=client-cert.pem --tlskey=client-key.pem -H=192.168.205.11:2376 info
```

## SSH Deploy Keys for private repositories
If a course repository is private, ACCESS uses deploy keys. The issue with deploy keys is that (at least on github) 
a deploy key can be used only once. So if multiple private repos live on the same server (e.g. Github.com), we need to use different deploy keys for each repo.
However ACCESS does not have a mechanism for selecting private keys and just delegates everything to ssh and ssh_config.
See [SSH Aliasing](#ssh-aliasing)

Run the following script to create the necessary deploy keys.

```bash
chmod u+x generate-repo-keys.sh
HOST=github.com ./generate-repo-keys.sh
```

Move the generated files to `host_files/{{ inventory_hostname }}/git/` and encrypt the files with:
```bash
ansible-vault encrypt host_files/{{ inventory_hostname }}/git/*
```

Move the generated `ssh_config` to `host_files/{{ inventory_hostname }}/ssh_config`

One key is needed per repository, remove any additional keys and their entries from the ssh_config file.
Rename the host aliases so that it is more human-readable and correct any urls in `repositories.json`

### SSH Aliasing
If multiple repositories (on the same server) are needed use the Host aliasing mechanism to avoid issues with the deploy keys.

For example if 2 repositories are hosted at `github.com` edit the `ssh_config` and `repositories.json` files:

````ssh_config
Host prod.github.com
  HostName github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa_0

Host staging.github.com
  HostName github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa_1
````

```json
{
  "repositories": [
    "git@prod.github.ifi.uzh.ch:seal/access/course-prod.git",
    "git@staging.github.ifi.uzh.ch:seal/access/course-staging.git"
  ]
}
```

## Repository configuration
On the repository add the generated public keys as deploy key.
On Github: https://github.com/mp-access/Private-Mock-Course/settings/keys

## Install ACCESS
The entire process is scripted using ansible. 

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

Once the steps above are done (only needed once for every new deployment), the following two commands can be used:

```bash
ansible-playbook -i vm.hosts worker.yml
ansible-playbook -i vm.hosts access.yml
```

### Worker and Main servers on the same machine
Instead of running both playbooks run the simplified playbook `single-server.yml`.

```bash
ansible-playbook -i vm.hosts single-server.yml
```

## Testing on VMs
See [Vagrant](ops/ansible/test-systems/README.md).

# Testing connection to hosts
You can use the ping module to verify the connection to an inventory
```bash
ansible -i digitalocean.hosts all -m ping
```
