# ECR pull-through cache implementation

Starting from April 1, 2025 Docker Hub introduces new rate limits

This was made to create ECR pull-through cache for other registries (both public and private) and can be used to:

- caching public and private images in your private ECR registry
- speedup pulling from private ECR to your local services (ECS, EKS, Lambdas, etc.)
- define lifecycle policy to keep only the required number of the latest tags
- security scanning of images during pull
- a single place to update your token in case of rotation or expiration (e.g. Gitlab do not allow you to create tokens with an expiration date longer than one year). Just imagine you need to go through all your credentials in all K8s clusters one per year to update tokens.

```sh
# direct pull from Docker Hub
docker pull timberio/vector:0.45.0-alpine
# pull through ECR
docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/dockerhub/timberio/vector:0.45.0-alpine
```

If in YAML not specified `lifecycle_policy` module applies following default lifecycle policy to each created template:
```
lifecycle_policy:
    rules:
        - rulePriority: 1
            description: "Keep last 3 images"
            selection:
            tagStatus: "any"
            countType: "imageCountMoreThan"
            countNumber: 3
            action:
            type: "expire"
```

More details about this module in <a name="blog post"></a> [blog post](https://sirantd.com/aws-and-docker-hub-limits-smart-strategies-for-april-2025-changes-42bd9295cad6)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.75.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.89.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pull_through_cache_repository_template"></a> [pull\_through\_cache\_repository\_template](#module\_pull\_through\_cache\_repository\_template) | terraform-aws-modules/ecr/aws//modules/repository-template | 2.3.1 |
| <a name="module_secrets_manager_credentials"></a> [secrets\_manager\_credentials](#module\_secrets\_manager\_credentials) | terraform-aws-modules/secrets-manager/aws | 1.3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region where we are creating rules | `string` | `""` | no |
| <a name="input_registries"></a> [registries](#input\_registries) | List of registries to create rules for | <pre>map(object({<br/>    registry                    = string<br/>    username                    = optional(string)<br/>    accessToken                 = optional(string)<br/>    repository_read_access_arns = optional(list(string))<br/>    image_tag_mutability        = optional(string)<br/>    lifecycle_policy = optional(object({<br/>      rules = list(object({<br/>        rulePriority = number<br/>        description  = string<br/>        selection = object({<br/>          tagStatus   = string<br/>          countType   = string<br/>          countNumber = number<br/>        })<br/>        action = object({<br/>          type = string<br/>        })<br/>      }))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be assigned to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pull_through_cache_urls"></a> [pull\_through\_cache\_urls](#output\_pull\_through\_cache\_urls) | List of ECR pull-through cache URLs for your images |
<!-- END_TF_DOCS -->
