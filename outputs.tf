output "pull_through_cache_urls" {
  description = "List of ECR pull-through cache URLs for your images"
  value = {
    for name, _ in var.registries :
    name => "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${name}/your_image:tag"
  }
}
