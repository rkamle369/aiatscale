include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/azure/subnet"

  extra_arguments "component_tfvars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/tfvars/prod/azure/spoke-network/subnet-db.tfvars"
    ]
  }
}
