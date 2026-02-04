module "vpc" {
  source = "./modules/vpc"
}


module "sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  ecs_task_port  = var.ecs_task_port
}

module "alb" {
  source            = "./modules/alb"
  alb_sg_id         = module.sg.alb_sg_id
  vpc_id            = module.vpc.vpc_id
  ecs_task_port     = var.ecs_task_port
  alb_subnet_public = [module.vpc.ecs_subnet_public_2a_id, module.vpc.ecs_subnet_public_2a_id]
}

