variable "string" {
  type    = string
  default = "stringValue"
}
##

variable "boolean" {
  type    = bool
  default = false
}

variable "number" {
  type    = number
  default = 12
}

variable "float" {
  type    = number
  default = 15.55
}

# variable "null" {
#   type = null
#   default = null
# }

variable "list" {
  type    = list(any)
  default = ["322", true, 15.22]
}

variable "map" {
  type = map(any)
  default = {
    key1 = "value 1"
    key2 = "value 2"
  }
}

variable "object" {
  type = object({
    ob_1 = bool
    ob_2 = string
  })
  default = {
    ob_1 = true
    ob_2 = "stringObjectValue"
  }
}

resource "null_resource" "test" {
  triggers = {
    trigger = "1"
  }
}

output "var_map_key_1" {
  value = var.map.key1
}

output "var_map_key_2" {
  value = var.map.key2
}

output "var_map" {
  value = var.map
}

output "CAPITALIZED_OUTPUT" {
  value = "BIG LETTERS ARE GOOD"
}
