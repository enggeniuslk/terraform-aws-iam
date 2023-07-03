module "example" {
  source    = "../../"
  data_path = "./test/data"

  tags = {}
}

output "debug" {
  value = module.example.role_arns
}