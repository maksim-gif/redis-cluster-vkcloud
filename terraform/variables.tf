variable "vkcs_username" {
  description = "VK Cloud username"
  type        = string
}

variable "vkcs_password" {
  description = "VK Cloud password"
  type        = string
  sensitive   = true
}

variable "vkcs_project_id" {
  description = "VK Cloud project ID"
  type        = string
}

variable "vkcs_region" {
  description = "VK Cloud region"
  type        = string
  default     = "RegionOne"
}

variable "vkcs_auth_url" {
  description = "VK Cloud auth URL"
  type        = string
  default     = "https://infra.mail.ru:35357/v3/"
}

variable "lastname" {
  description = "Your lastname for VM naming"
  type        = string
  default     = "PanyutinMA"
}

variable "compute_flavor" {
  type    = string
  default = "STD2-2-4"
}

variable "key_pair_name" {
  type    = string
  default = "keypair-terraform"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}
