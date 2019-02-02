terraform {
  required_version = "~>0.11.11"

  backend "s3" {
    bucket                  = "xyz-tfm-state"
    region                  = "eu-west-1"
    key                     = "containers.tfstate"
    encrypt                 = "true"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "default"
  }
}

data "terraform_remote_state" "flaskapi_base" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_s3}"
    region = "eu-west-1"
    key    = "env:/${terraform.workspace}/flaskapi-base.tfstate"
  }
}
