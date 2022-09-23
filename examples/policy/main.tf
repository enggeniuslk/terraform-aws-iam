module "example" {
    source = "../../"
    data_path = "./data"

    tags={}
}

output "debug" {
  value = module.example.policy_arns
}