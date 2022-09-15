variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "prefix" {
  type     = string
  nullable = true
}

variable "suffix" {
  type     = string
  nullable = true
}

variable "security_groups" {
  type = set(object({
    name        = string
    description = optional(string)
  }))
}

variable "aliases" {
  type        = map(string)
  description = "name -> source"
  default     = {}
}

variable "enable_rules" {
  type    = bool
  default = true
}

variable "rules" {
  type = set(object({
    type        = string # ingress | egress
    protocol    = string # tcp | udp | all
    port        = optional(number)
    port_range  = optional(string)
    source      = string
    target      = string
    description = optional(string)
  }))
  default = []
}

output "security_groups" {
  value = local.security_groups
}

output "debug" {
  value = {
    aliases      = var.aliases
    enable_rules = var.enable_rules
    rules        = var.rules
  }
}