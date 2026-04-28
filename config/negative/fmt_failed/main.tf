resource "terraform_data" "x" {
  input = "value"
  triggers_replace = [ timestamp() ]
}

resource "null_resource" "x" {
   triggers = {   # three spaces instead of two
      key = "value"
   }
}