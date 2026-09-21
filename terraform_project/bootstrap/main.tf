# create ecr
module "ecr" {
  source       = "../modules/ecr"
  project_name = var.project_name
}

# artifact s3 bucket
module "s3_artifacts" {
  source       = "../modules/s3"
  project_name = var.project_name
}

# create all required roles
module "iam_roles" {
  source                = "../modules/iam"
  project_name          = var.project_name
  artifacts_bucket_arn  = module.s3_artifacts.artifacts_bucket_arn
  frontend_ecr_repo_arn = module.ecr.frontend_ecr_repo_arn
  backend_ecr_repo_arn  = module.ecr.backend_ecr_repo_arn
  codeconnections_id    = "5fd2ca39-3397-4cc2-bbe7-6c53deee9574"
}

# ssm parameter store for prod infra
module "ssm_parameter_store_prod" {
  source                = "../modules/parameterstore_prod"
  project_name          = var.project_name
  aws_region            = var.aws_region
  hosted_zone_id        = var.hosted_zone_id
  domain_name           = var.domain_name
  site_full_domain_name = var.site_full_domain_name
  email_address         = var.email_address
  repo_owner            = var.repo_owner
  app_repo_name         = var.app_repo_name
  codeconnections_arn   = var.codeconnections_arn
  repo_name             = var.repo_name
  state_bucket_name     = var.state_bucket_name
  state_bucket_key      = var.state_bucket_key
}

# codebuild infra
module "codebuild_infra" {
  source             = "../modules/codebuild_infra"
  project_name       = var.project_name
  codebuild_role_arn = module.iam_roles.codebuild_role_arn
  tf_admin_role_arn  = module.iam_roles.tf_admin_role_arn
}

# create infra pipeline 
module "infra_pipeline" {
  source                 = "../modules/codepipeline_infra"
  project_name           = var.project_name
  artifacts_bucket_name  = module.s3_artifacts.artifacts_bucket_name
  codepipeline_role_arn  = module.iam_roles.codepipeline_role_arn
  codebuild_project_name = module.codebuild_infra.build_project_name
  repo_owner             = var.repo_owner
  repo_name              = var.repo_name
  branch                 = "main"
  codeconnection_arn     = var.codeconnections_arn
}


