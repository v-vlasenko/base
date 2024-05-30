variable "locations" {
  type = map(object({
    cidr     = string
    zone     = string
    tags     = map(string)
    cidr_app = string
    gw_app   = string
    cidr_db  = string
    gw_db    = string
  }))
}
#ok
variable "number-hcl" {
  type = number
}

variable "bool-hcl" {
  type = bool
}

variable "sens-number-hcl" {
  type = number
  sensitive = true
}

variable "sens-bool-hcl" {
  type = bool
  sensitive = true
}

variable "sens-list-hcl" {
  type = list(string)
  sensitive = true
}

variable "list-untyped" {
  
}

variable "sens-object" {
  type = object({
    id = string
    labels = map(string)
    size = number
  })
  sensitive = true
}

variable "type-any" {
  type = any
}

variable "with-optional-attribute" {
  type = object({
    a = string                
    b = optional(string)      
    c = optional(number, 127) 
  })
}

variable "nullable_var" {
  type     = string
  nullable = true
  default  = null
}

resource "null_resource" "map-of-objects" {
  provisioner "local-exec" {
    command = "echo ${var.locations.AIMS.cidr}"
  }
  triggers = {
    time = timestamp()
  }
}

resource "random_password" "number-and-bool" {
  length           = var.number-hcl
  special          = var.bool-hcl
  override_special = "!#$%&*()-_=+[]{}<>:?"
}



resource "random_password" "sens-number-and-bool" {
  length           = var.sens-number-hcl
  special          = var.sens-bool-hcl
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

variable "list-hcl" {
  type = list(object({
    password-length = number
    password-special = bool
    password-override-special = string
  }))
}

resource "random_password" "list-of-objects" {
  length           = var.list-hcl[0].password-length
  special          = var.list-hcl[0].password-special
  override_special = var.list-hcl[0].password-override-special
}

resource "random_shuffle" "name" {
  input = var.sens-list-hcl
}

resource "terraform_data" "list-untyped-and-sens-object" {
  input = var.list-untyped
  triggers_replace  = var.sens-object
}


resource "null_resource" "nullable_trigger" {
  triggers = {
    example_variable = var.nullable_var != null ? var.nullable_var : "default_value"
  }
}

output "nullable_output" {
  value = var.nullable_var
}

output "type-any-out" {
  value = jsonencode(var.type-any)
}

output "optional-attributes-out" {
  value = var.with-optional-attribute
}

variable "key-name" {
  type        = string
}

locals {
  map_with_non_literal_key = {
    stable = "constant"
    (var.key-name) = "unstable"
  }
}

resource "null_resource" "triggered-by-non-literal-map" {
  triggers = local.map_with_non_literal_key
}

output "map_with_non_literal_key_output" {
  value = local.map_with_non_literal_key
}
