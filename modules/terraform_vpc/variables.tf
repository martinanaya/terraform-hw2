variable "cidr_block" {
    type = string
    description = "IP Scope"
    default = "172.250.0.0/16"
}

variable "all_ips" {
    type = string
    default = "0.0.0.0/10"
}