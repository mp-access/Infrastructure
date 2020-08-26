resource "local_file" "digitalocean_hosts" {
    content = templatefile("${path.module}/templates/hosts.tpl",
    {
      access_ip_addr = digitalocean_droplet.access.ipv4_address
      access_worker_ip_addr = digitalocean_droplet.access-worker.ipv4_address
    }
  )
  filename = "${path.module}/../ansible/control-node/digitalocean.hosts"
}
