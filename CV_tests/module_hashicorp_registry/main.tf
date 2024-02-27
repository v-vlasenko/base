module "label" {
    source  = "cloudposse/label/null"
    version = "0.25.0"

    namespace = "qa"
    environment = "mshytse"
    stage = "test"
    name = "example"
    attributes = ["attr1", "attr2"]
    tags = {
        "executor" = "scalr-run"
    }
}

output "string_id" {
  value = module.label.id
}

output "string_tags" {
  value = module.label.tags
}