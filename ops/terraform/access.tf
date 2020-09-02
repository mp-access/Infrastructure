resource "digitalocean_droplet" "access" {
  image = "docker-18-04"
  name = "access"
  region = "fra1"
  size = "s-1vcpu-2gb"
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

output "access_ip_addr" {
  value = digitalocean_droplet.access.ipv4_address
}
