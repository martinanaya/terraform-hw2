variable "tag_name" {
  default = "mainVPC"
}

variable "vpc-cidr" {
  default = "172.172.0.0/16"
}

variable "availability_zone" {
  default = "us-west-1"
}

variable "baseName" {
  description = "Prefix for all resource names"
  default = "Terr2-"
}
