# ECR pull-trhough cache implementation

## You can find information about this module in my blog https://sirantd.com/

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.75.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.88.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pull_through_cache_repository_template"></a> [pull\_through\_cache\_repository\_template](#module\_pull\_through\_cache\_repository\_template) | terraform-aws-modules/ecr/aws//modules/repository-template | 2.3.1 |
| <a name="module_secrets_manager_credentials"></a> [secrets\_manager\_credentials](#module\_secrets\_manager\_credentials) | terraform-aws-modules/secrets-manager/aws | 1.3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region where we are creating rules | `string` | `""` | no |
| <a name="input_registries"></a> [registries](#input\_registries) | List of registries to create rules for | <pre>map(object({<br/>    registry    = string<br/>    username    = optional(string)<br/>    accessToken = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be assigned to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pull_through_cache_urls"></a> [pull\_through\_cache\_urls](#output\_pull\_through\_cache\_urls) | List of ECR pull-through cache URLs for your images |
<!-- END_TF_DOCS -->
