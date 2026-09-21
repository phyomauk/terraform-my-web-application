terraform {
  backend "s3" {
    bucket       = "phyomauk-terraform-state-file-bucket-us-west-2"
    key          = "web-application/environments/prod/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}