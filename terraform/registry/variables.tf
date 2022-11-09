variable "registry_name" {
  type = string
}
variable "service_name" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "image_tag" {
  type        = string
  description = "Given image tag for the current deployment."
}
variable "account_id" {
  type        = string
  description = "ID of the AWS account"
}
variable "private_subnet" {
  type        = string
  description = "This configures the private subnet cidr"
  default     = "10.0.1.0/24"
}

variable "public_subnet" {
  type        = string
  description = "This configures the prublic subnet cidr"
  default     = "10.0.2.0/24"
}
