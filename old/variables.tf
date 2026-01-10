# variable "instance_type" {
#   type        = string                     # The type of the variable, in this case a string
#   default     = "t2.micro"                 # Default value for the variable
#   description = "The type of EC2 instance" # Description of what this variable represents
# }
#
# variable "ami_id" {
#   type        = string                                                          # The type of the variable, in this case a string
#   default     = "ami-046c2381f11878233"                                         # Default value for the variable
#   description = "The default Ubuntu ami id for t2.micro eu-west-2 ec2 instance" # Description of what this variable represents
# }
#
#
# variable "ssh_key_name" {
#   description = "Name for the EC2 key pair"
#   type        = string
#   default     = "wp-ssh-key"
# }
#
# variable "ssh_public_key_path" {
#   description = "Path to your *public* key (e.g., ~/testkey.pub)"
#   type        = string
#   default     = "~/testkey.pub"
# }
#
# variable "ssh_ingress_cidr" {
#   description = "Your public IP in CIDR (x.x.x.x/32)"
#   type        = string
#   default     = "148.252.128.194/32"
# }
