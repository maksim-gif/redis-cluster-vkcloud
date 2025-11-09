resource "vkcs_networking_secgroup" "redis_secgroup" {
  name = "redis-security-group"
}

resource "vkcs_networking_secgroup_rule" "ssh" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.redis_secgroup.id
}

resource "vkcs_networking_secgroup_rule" "redis" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 6379
  port_range_max    = 6379
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.redis_secgroup.id
}

resource "vkcs_networking_secgroup_rule" "sentinel" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 26379
  port_range_max    = 26379
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.redis_secgroup.id
}

resource "vkcs_networking_secgroup_rule" "icmp" {
  direction         = "ingress"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.redis_secgroup.id
}
