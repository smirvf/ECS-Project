output "vpc_id" {
  value       = aws_vpc.ecs_vpc.id
  description = "vpc id for ecs proj"
}

output "ecs-subnet-public-2a-id" {
  value       = aws_subnet.ecs_subnet_public_2a.id
  description = "ECS Proj Subnet Pub 2a id"
}
output "ecs-subnet-public-2b-id" {
  value       = aws_subnet.ecs_subnet_public_2b.id
  description = "ECS Proj Subnet Pub 2b id"
}
output "ecs-subnet-private-2a-id" {
  value       = aws_subnet.ecs_subnet_private_2a.id
  description = "ECS Proj Subnet Private 2a id"
}
output "ecs-subnet-private-2b-id" {
  value       = aws_subnet.ecs_subnet_private_2b.id
  description = "ECS Proj Subnet Private 2b id"
}