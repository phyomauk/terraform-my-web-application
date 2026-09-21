# Networking
module "networking" {
  source       = "../../modules/networking"
  project_name = var.project_name
  vpc_cidr     = "10.10.0.0/16"
}

# Security groups
module "sg" {
  source       = "../../modules/sg"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

# SSM Parameter Store
module "ssm_parameter_store" {
  source                    = "../../modules/parameterstore"
  project_name              = var.project_name
  docdb_endpoint            = module.docdb.cluster_endpoint
  docdb_username            = "docdbadmin"
  docdb_instance_dependency = module.docdb
  site_domain               = var.site_full_domain_name

}

# DocumentDB
module "docdb" {
  source           = "../../modules/documentdb"
  project_name     = var.project_name
  vpc_id           = module.networking.vpc_id
  docdb_subnet_ids = module.networking.docdb_subnet_ids
  docdb_sg_id      = module.sg.docdb_sg
  ecs_sg_id        = module.sg.ecs_sg_id
  master_username  = module.ssm_parameter_store.docdb_username
  master_password  = module.ssm_parameter_store.docdb_password
  depends_on = [
    module.ssm_parameter_store.docdb_username,
    module.ssm_parameter_store.docdb_password
  ]
}

locals {
  deployment_region = var.aws_region
  state_bucket_name = var.state_bucket_name
  state_bucket_key  = var.state_bucket_key
}

# referecing bootstrap state file
data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket = var.state_bucket_name
    key    = var.state_bucket_key
    region = var.aws_region
  }
}

# ecs
module "ecs" {
  source                      = "../../modules/ecs"
  project_name                = var.project_name
  log_group_name              = module.cloud_watch.log_group_name
  ecs_task_execution_role_arn = data.terraform_remote_state.bootstrap.outputs.ecs_task_execution_role_arn
  frontend_repository_url     = data.terraform_remote_state.bootstrap.outputs.frontend_ecr_url
  backend_repository_url      = data.terraform_remote_state.bootstrap.outputs.backend_ecr_url
  private_subnet_ids          = module.networking.private_subnet_ids
  ecs_sg_id                   = module.sg.ecs_sg_id
  blue_target_group_arn       = module.alb.blue_target_group_arn
  docdb_uri_arn               = module.ssm_parameter_store.docdb_uri_arn

  depends_on = [
    module.alb.blue_target_group_arn,
    module.alb.green_target_group_arn,
    module.alb.production_listener_arn,
    module.alb.test_listener_arn,
    module.docdb,
    module.ssm_parameter_store.docdb_uri
  ]
}

# ALB
module "alb" {
  source          = "../../modules/alb"
  project_name    = var.project_name
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnet_ids
  alb_sg_id       = module.sg.alb_sg_id
  certificate_arn = module.ssm_parameter_store.cert_arn
}

# DNS Record Creation
module "route53" {
  source         = "../../modules/route53"
  project_name   = var.project_name
  hosted_zone_id = var.hosted_zone_id
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
  domain_name    = var.domain_name
}

# SNS Service
module "sns" {
  source        = "../../modules/sns"
  project_name  = var.project_name
  email_address = var.email_address
}

# CloudWatch
module "cloud_watch" {
  source                        = "../../modules/cloudwatch"
  project_name                  = var.project_name
  ecs_cluster_name              = module.ecs.ecs_cluster_name
  ecs_service_name              = module.ecs.ecs_service_name
  alb_arn_suffix                = module.alb.alb_arn_suffix
  sns_topic_arn                 = module.sns.topic_arn
  aws_region                    = var.aws_region
  green_target_group_arn_suffix = module.alb.green_target_group_arn_suffix
}

# WAF
module "waf" {
  source       = "../../modules/waf"
  project_name = var.project_name
  alb_arn      = module.alb.alb_arn
}

###########################################################
## Application Pipeline
###########################################################

# Codedeploy App
module "codedeploy" {
  source                  = "../../modules/codeploy"
  project_name            = var.project_name
  codedeploy_role_arn     = data.terraform_remote_state.bootstrap.outputs.codedeploy_role_arn
  ecs_cluster_name        = module.ecs.ecs_cluster_name
  ecs_service_name        = module.ecs.ecs_service_name
  target_group_blue_name  = module.alb.blue_target_group_name
  target_group_green_name = module.alb.green_target_group_name
  alb_listener_prod_arn   = module.alb.production_listener_arn
  alb_listener_test_arn   = module.alb.test_listener_arn

}

# codebuild_app
module "codebuild_app" {
  source                      = "../../modules/codebuild_app"
  project_name                = var.project_name
  codebuild_role_arn          = data.terraform_remote_state.bootstrap.outputs.codebuild_role_arn
  ecr_hostname                = data.terraform_remote_state.bootstrap.outputs.ecr_hostname
  frontend_ecr_repo_url       = data.terraform_remote_state.bootstrap.outputs.frontend_ecr_repo_url
  frontend_ecr_repo_name      = data.terraform_remote_state.bootstrap.outputs.frontend_ecr_repo_name
  backend_ecr_repo_url        = data.terraform_remote_state.bootstrap.outputs.backend_ecr_repo_url
  backend_ecr_repo_name       = data.terraform_remote_state.bootstrap.outputs.backend_ecr_repo_name
  frontend_container_name     = "frontend"
  backend_container_name      = "backend"
  image_tag                   = "latest"
  ecs_task_execution_role_arn = data.terraform_remote_state.bootstrap.outputs.ecs_task_execution_role_arn
  log_group_name              = module.cloud_watch.log_group_name
  docdb_uri_arn               = module.ssm_parameter_store.docdb_uri_arn

}


# codepipeline_app
module "app_pipeline" {
  source                      = "../../modules/codepipeline_app"
  project_name                = var.project_name
  artifacts_bucket_name       = data.terraform_remote_state.bootstrap.outputs.artifacts_bucket_name
  codepipeline_role_arn       = data.terraform_remote_state.bootstrap.outputs.codepipeline_role_arn
  codebuild_project_name      = module.codebuild_app.build_project_name
  repo_owner                  = var.repo_owner
  app_repo_name               = var.app_repo_name
  branch                      = "main"
  codeconnections_arn         = var.codeconnections_arn
  deployment_group_name       = module.codedeploy.deployment_group_name
  codedeploy_application_name = module.codedeploy.application_name
}