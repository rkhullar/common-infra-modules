variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "names" {
  type = object({
    load_balancer = string
    linux_runtime = string
    data_runtime  = string
  })
}

variable "descriptions" {
  type = object({
    load_balancer = optional(string)
    linux_runtime = optional(string)
    data_runtime  = optional(string)
  })
}

variable "rules" {
  type = map(
    object({
      ingress = object({
        ports       = list(number)
        port_ranges = list(string)
        sources     = list(string)
      })
      egress = object({
        ports       = list(number)
        port_ranges = list(string)
        targets     = list(string)
      })
    })
  )
}