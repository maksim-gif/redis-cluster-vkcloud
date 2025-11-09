output "master_instance_fip" {
  value = vkcs_networking_floatingip.fip_ms1.address
}

output "replica1_instance_fip" {
  value = vkcs_networking_floatingip.fip_gz1.address
}

output "replica2_instance_fip" {
  value = vkcs_networking_floatingip.fip_me1.address
}

output "connection_instructions" {
  value = <<EOT

Redis Cluster Configuration:
- Master (MS1):     ${vkcs_networking_floatingip.fip_ms1.address}
- Replica 1 (GZ1):  ${vkcs_networking_floatingip.fip_gz1.address}
- Replica 2 (ME1):  ${vkcs_networking_floatingip.fip_me1.address}

Connect to any node:
  ssh ubuntu@${vkcs_networking_floatingip.fip_ms1.address}

After setup, install Redis:
  sudo apt update && sudo apt install -y redis-server redis-sentinel
EOT
}
