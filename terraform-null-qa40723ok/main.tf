# cp1252 — dash in a module comment
variable "name" {
  type        = string
  description = "Name input"
}
output "greeting" { value = "hello ${var.name}" }
