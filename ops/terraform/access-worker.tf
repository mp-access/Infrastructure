resource "digitalocean_droplet" "access-worker" {
  image = "docker-18-04"
  name = "access-worker"
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    var.ssh_fingerprint
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
}

output "access_worker_ip_addr" {
  value = digitalocean_droplet.access-worker.ipv4_address
}
