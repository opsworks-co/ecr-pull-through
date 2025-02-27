locals {
  ### It's much simplier if you are using SOPS, see terragrunt.hcl example
  registries = tomap({
    for k, v in yamldecode(file("secrets.dec.yaml")) :
    k => {
      registry                    = v.registry
      username                    = try(v.username, null)
      accessToken                 = try(v.accessToken, null)
      repository_read_access_arns = try(v.repository_read_access_arns, [])
      image_tag_mutability        = try(v.image_tag_mutability, "MUTABLE")
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