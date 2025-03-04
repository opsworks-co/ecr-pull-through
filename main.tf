locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = var.region != "" ? var.region : data.aws_region.current.name
  default_lifecycle_policy = {
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 3
        }
        action = {
          type = "expire"
        }
      }
    ]
  }
  repository_read_access_arns = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

module "pull_through_cache_repository_template" {
  for_each = var.registries

  source  = "terraform-aws-modules/ecr/aws//modules/repository-template"
  version = "2.3.1"

  # Template
  description   = "Pull through cache repository template for ${each.key} artifacts"
  prefix        = each.key
  resource_tags = var.tags

  repository_read_access_arns = concat(coalesce(lookup(each.value, "repository_read_access_arns", []), []), local.repository_read_access_arns)
  image_tag_mutability        = coalesce(lookup(each.value, "image_tag_mutability", "MUTABLE"), "MUTABLE")

  lifecycle_policy = jsonencode(coalesce(lookup(each.value, "lifecycle_policy", local.default_lifecycle_policy), local.default_lifecycle_policy))

  # Pull through cache rule
  create_pull_through_cache_rule = true
  upstream_registry_url          = each.value.registry
  credential_arn                 = contains(keys(module.secrets_manager_credentials), each.key) ? module.secrets_manager_credentials[each.key].secret_arn : null

  tags = var.tags
}

module "secrets_manager_credentials" {
  for_each = {
    for key, registry in var.registries : key => registry
    if registry.username != null && registry.accessToken != null
  }
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.3.1"

  name_prefix = "ecr-pullthroughcache/${each.key}"
  description = "${each.key} credentials"

  recovery_window_in_days = 0
  secret_string = jsonencode({
    username    = each.value.username
    accessToken = each.value.accessToken
  })

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.account_id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  tags = var.tags
}
