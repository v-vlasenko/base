run "default_name" {
  command = apply

  assert {
    condition     = output.greeting == "hello world"
    error_message = "greeting did not use the default name"
  }
}

run "custom_name" {
  command = apply

  variables {
    name = "scalr"
  }

  assert {
    condition     = output.greeting == "hello scalr"
    error_message = "greeting did not use the supplied name"
  }
}