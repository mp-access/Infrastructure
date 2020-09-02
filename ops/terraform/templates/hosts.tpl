[main]
access-do-main ansible_host=${access_ip_addr}

[worker]
access-do-worker ansible_host=${access_worker_ip_addr}

[main:vars]
ansible_ssh_user=root
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[worker:vars]
ansible_ssh_user=root
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
