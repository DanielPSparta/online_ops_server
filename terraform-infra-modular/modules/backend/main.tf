terraform {
  backend "s3" {
    bucket = var.var_aws_bucket_id
    key = "tfstate/terraform_full_infra_calculator/terraform.tfstate"
    region = var.var_region
    dynamodb_table = "cyber94_dpook_dynamodb_table_lock_calculator"
    encrypt = true
  }
}
