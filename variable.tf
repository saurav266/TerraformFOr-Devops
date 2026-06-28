variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_root_storage_size" {
  type    = number
  default = 15
}