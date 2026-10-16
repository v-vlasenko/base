variable "name" {
  type        = string
  description = "Something — cp1252"
}
output "greeting" { value = "hello ${var.name}" }
