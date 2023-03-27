variable project_name {
  type        = string
  default     = ""

}


variable region {
  type        = string
  default     = "europe-west1"

}

variable zone {
  type        = string
  default     = "europe-west1-b"

}


variable network {
  type        = string
  default     = "bastion-vpc"

}

variable subnetwork {
  type        = string
  default     = "bastion-subnetwork"
}

variable subnetwork_ip_range {
  type        = string
  default     = "10.0.0.0/24"
}

variable instance_bastion_name {
  type        = string
  default     = "bastion-vm"
}

variable instance_name {
  type        = string
  default     = ""
}
variable instance_machine_type {
  type        = string
  default     = "f1-micro"

}

variable instance_image {
  type        = string
  default     = "debian-11"

}



variable ssh_user {
  type        = string
  default     = ""
}

variable public_key_path {
    default = ""   ##public key with path
}

variable private_key_path{
    default = ""
}

