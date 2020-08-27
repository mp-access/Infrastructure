# Terraform

This folder includes the terraform configs to create DigitalOcean servers for deployment


## Directory structure

```bash
.
├── README.md
├── access-worker.tf
├── access.tf
├── domain.tf
├── output.tf
├── provider.tf
├── templates
│   └── hosts.tpl
├── terraform.tfplan
├── terraform.tfstate
└── terraform.tfstate.backup
```

## Getting Started

Initialize:
```bash
terraform init

# Get SSH Key fingerprint
ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}' # print MD5:74:...:15
export DO_SSH_FINGERPRINT=74:...:15

# Export DigitalOcean API token
export DO_PAT=b...23
```

Plan deployment:
```bash
terraform plan -out=out.tfplan  -var "do_token=${DO_PAT}"   -var "pub_key=$HOME/.ssh/id_rsa.pub"   -var "pvt_key=$HOME/.ssh/id_rsa"   -var "ssh_fingerprint=${DO_SSH_FINGERPRINT}" 
```

Apply plan:
```bash
terraform apply out.tfplan
```

Destroy everything:
````bash
terraform plan -destroy -out=out.tfplan -var "do_token=${DO_PAT}" -var "pub_key=$HOME/.ssh/id_rsa.pub" -var "pvt_key=$HOME/.ssh/id_rsa" -var "ssh_fingerprint=${DO_SSH_FINGERPRINT}"
````
