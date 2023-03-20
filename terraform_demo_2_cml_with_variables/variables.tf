variable "address" {
  description = "CML controller address"
  type        = string
}

variable "username" {
  description = "cml2 username"
  type        = string
}

variable "password" {
  description = "cml2 password"
  type        = string
  sensitive   = true
}

variable "topology_name" {
  description = "YAML file to import"
  type        = string
}

variable "state" {
  description = "Set the initial node state. By default they are all powered on"
  type        = string
  default     = "STARTED"
}

variable "configuration_variables" {
  type = object({
    device_username = string
    device_password   = string
  })
}