provider "aws" {
  version                 = "~>1.9"
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  allowed_account_ids     = ["${var.account_id}"]
}
