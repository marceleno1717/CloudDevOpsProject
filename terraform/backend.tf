terraform {
  backend "s3" {
    bucket       = "iv-devops-tfstate-bucket"
    key          = "eks-project/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }
}
