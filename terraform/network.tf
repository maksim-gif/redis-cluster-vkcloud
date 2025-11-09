data "vkcs_networking_network" "extnet" {
  name = "ext-net"
}

resource "vkcs_networking_network" "redis_network" {
  name           = "redis-network"
  admin_state_up = true
}

resource "vkcs_networking_subnet" "redis_subnet" {
  name            = "redis-subnet"
  network_id      = vkcs_networking_network.redis_network.id
  cidr            = "192.168.100.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "vkcs_networking_router" "redis_router" {
  name                = "redis-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "redis" {
  router_id = vkcs_networking_router.redis_router.id
  subnet_id = vkcs_networking_subnet.redis_subnet.id
}
