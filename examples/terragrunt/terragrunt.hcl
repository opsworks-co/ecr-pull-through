terraform {
	source = "../../"
}

include "root" {
	path = find_in_parent_folders("root.hcl")
	expose = true
}

locals {
	registries = yamldecode(sops_decrypt_file("secrets.enc.yaml"))
}

inputs = {
	registries = local.registries
	tags = merge(include.root.locals.default_tags)
}