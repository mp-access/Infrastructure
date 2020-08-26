resource "digitalocean_domain" "access" {
   name = "access.alpm.io"
   ip_address = digitalocean_droplet.access.ipv4_address
}

resource "digitalocean_record" "CNAME-access" {
  domain = digitalocean_domain.access.name
  type = "CNAME"
  name = "www"
  value = "@"
}

resource "digitalocean_domain" "worker" {
   name = "worker.access.alpm.io"
   ip_address = digitalocean_droplet.access-worker.ipv4_address
}

resource "digitalocean_record" "CNAME-worker-access" {
  domain = digitalocean_domain.worker.name
  type = "CNAME"
  name = "www"
  value = "@"
}