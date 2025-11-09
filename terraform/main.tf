# Данные для flavor
data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

# Данные для образа Ubuntu 22.04
data "vkcs_images_image" "compute" {
  visibility  = "public"
  most_recent = true
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "22.04"
  }
}

# Ключ для доступа по SSH
resource "vkcs_compute_keypair" "redis_keypair" {
  name       = var.key_pair_name
  public_key = var.ssh_public_key
}

# ВМ в зоне MS1 (Master)
resource "vkcs_compute_instance" "redis_ms1" {
  name               = "Ubuntu-${var.lastname}-ms1"
  flavor_id          = data.vkcs_compute_flavor.compute.id
  key_pair           = vkcs_compute_keypair.redis_keypair.name
  security_group_ids = ["default", vkcs_networking_secgroup.redis_secgroup.id]
  availability_zone  = "MS1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.redis_network.id
  }

  depends_on = [
    vkcs_networking_router_interface.redis
  ]
}

# ВМ в зоне GZ1 (Replica 1)
resource "vkcs_compute_instance" "redis_gz1" {
  name               = "Ubuntu-${var.lastname}-gz1"
  flavor_id          = data.vkcs_compute_flavor.compute.id
  key_pair           = vkcs_compute_keypair.redis_keypair.name
  security_group_ids = ["default", vkcs_networking_secgroup.redis_secgroup.id]
  availability_zone  = "GZ1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.redis_network.id
  }
}

# ВМ в зоне ME1 (Replica 2)
resource "vkcs_compute_instance" "redis_me1" {
  name               = "Ubuntu-${var.lastname}-me1"
  flavor_id          = data.vkcs_compute_flavor.compute.id
  key_pair           = vkcs_compute_keypair.redis_keypair.name
  security_group_ids = ["default", vkcs_networking_secgroup.redis_secgroup.id]
  availability_zone  = "ME1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.redis_network.id
  }
}

# Floating IP для мастер-узла
resource "vkcs_networking_floatingip" "fip_ms1" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip_ms1" {
  floating_ip = vkcs_networking_floatingip.fip_ms1.address
  instance_id = vkcs_compute_instance.redis_ms1.id
}

# Floating IP для реплики 1
resource "vkcs_networking_floatingip" "fip_gz1" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip_gz1" {
  floating_ip = vkcs_networking_floatingip.fip_gz1.address
  instance_id = vkcs_compute_instance.redis_gz1.id
}

# Floating IP для реплики 2
resource "vkcs_networking_floatingip" "fip_me1" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip_me1" {
  floating_ip = vkcs_networking_floatingip.fip_me1.address
  instance_id = vkcs_compute_instance.redis_me1.id
}
