locals {
  ### It's much simplier if you are using SOPS, see terragrunt.hcl example
  registries = tomap({
    for k, v in yamldecode(file("secrets.dec.yaml")) :
    k => {
      registry    = v.registry
      username    = v.username
      accessToken = v.accessToken
    }
  })
}

module "ecr_pull_through" {
  source = "../../"

  registries = local.registries

  tags = {
    "ManagedBy" = "Terraform"
  }
}