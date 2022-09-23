module "test" {
    source = "../"
    data_path = "./data"

    tags={}
}

output "debug" {
  value = module.test.debug[*]
}