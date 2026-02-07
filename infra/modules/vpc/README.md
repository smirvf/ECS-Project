<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.ecs_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ecs_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.ecs_rtb_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.ecs_rtb_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.ecs_rt_private_2a_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ecs_rt_private_2b_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ecs_rt_public_2a_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ecs_rt_public_2b_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.ecs_subnet_private_2a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ecs_subnet_private_2b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ecs_subnet_public_2a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ecs_subnet_public_2b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.ecs_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS Region var | `string` | `"eu-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_subnet_private_2a_id"></a> [ecs\_subnet\_private\_2a\_id](#output\_ecs\_subnet\_private\_2a\_id) | ECS Proj Subnet Private 2a id |
| <a name="output_ecs_subnet_private_2b_id"></a> [ecs\_subnet\_private\_2b\_id](#output\_ecs\_subnet\_private\_2b\_id) | ECS Proj Subnet Private 2b id |
| <a name="output_ecs_subnet_public_2a_id"></a> [ecs\_subnet\_public\_2a\_id](#output\_ecs\_subnet\_public\_2a\_id) | ECS Proj Subnet Pub 2a id |
| <a name="output_ecs_subnet_public_2b_id"></a> [ecs\_subnet\_public\_2b\_id](#output\_ecs\_subnet\_public\_2b\_id) | ECS Proj Subnet Pub 2b id |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | vpc id for ecs proj |
<!-- END_TF_DOCS -->