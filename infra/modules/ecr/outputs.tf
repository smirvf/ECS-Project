# output "ec2ip" {
#   value = aws_instance.WordPressEC2.public_ip
# }
#
# output "instance_public_dns" {
#   value = aws_instance.WordPressEC2.public_dns
# }
#
# output "wp_url" { value = "http://${aws_instance.WordPressEC2.public_ip}" }
# output "ssh_cmd" { value = "ssh -i testkey ec2-user@${aws_instance.WordPressEC2.public_ip}" }

output "ecr_url" {
  value = module.ecr.threat
}
