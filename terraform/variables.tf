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
