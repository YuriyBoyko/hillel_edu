variable "aws_region" {
  default = "eu-central-1a"
}

variable "vpc_cidr" {
  description = "all subnets"
  default     = "10.0.0.0/16"
}


variable "vpc_cidr_public" {
  description = "Public subnet"
  default     = "10.0.1.0/24"
}

variable "vpc_cidr_private" {
  description = "Private subnet"
  default     = "10.0.101.0/24"
}
